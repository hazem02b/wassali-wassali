import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import apiService from '../services/api.service';

interface Trip {
  id: number;
  origin_city: string;
  destination_city: string;
  departure_date: string;
  max_weight: number;
  available_weight: number;
  price_per_kg: number;
  vehicle_info?: string;
  description?: string;
}

interface TripsContextType {
  trips: Trip[];
  loading: boolean;
  refreshTrips: () => Promise<void>;
  deleteTrip: (id: number) => Promise<void>;
  addTrip: (trip: Trip) => void;
  updateTrip: (id: number, trip: Trip) => void;
}

const TripsContext = createContext<TripsContextType | undefined>(undefined);

export function TripsProvider({ children }: { children: ReactNode }) {
  const [trips, setTrips] = useState<Trip[]>([]);
  const [loading, setLoading] = useState(false); // Start with false to avoid loading on mount

  const refreshTrips = async () => {
    setLoading(true);
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        setTrips([]);
        setLoading(false);
        return;
      }

      const user = localStorage.getItem('user');
      if (!user) {
        setTrips([]);
        setLoading(false);
        return;
      }

      const userData = JSON.parse(user);
      
      // Only fetch trips for transporters
      if (userData.type !== 'transporter' && userData.role !== 'transporter') {
        setTrips([]);
        setLoading(false);
        return;
      }

      const data = await apiService.getMyTrips(token);
      setTrips(data as Trip[]);
    } catch (err) {
      console.error('Error fetching trips:', err);
      setTrips([]);
    } finally {
      setLoading(false);
    }
  };

  const deleteTrip = async (id: number) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      const response = await fetch(`http://localhost:8000/api/v1/trips/${id}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.ok) {
        // Mettre à jour l'état local immédiatement
        setTrips(prevTrips => prevTrips.filter(t => t.id !== id));
      } else {
        throw new Error('Failed to delete trip');
      }
    } catch (err) {
      console.error('Error deleting trip:', err);
      throw err;
    }
  };

  const addTrip = (trip: Trip) => {
    setTrips(prevTrips => [trip, ...prevTrips]);
  };

  const updateTrip = (id: number, updatedTrip: Trip) => {
    setTrips(prevTrips => 
      prevTrips.map(t => t.id === id ? { ...t, ...updatedTrip } : t)
    );
  };

  useEffect(() => {
    const initTrips = async () => {
      const user = localStorage.getItem('user');
      if (user) {
        const userData = JSON.parse(user);
        // Only fetch trips for transporters
        if (userData.type === 'transporter' || userData.role === 'transporter') {
          await refreshTrips();
        } else {
          setLoading(false);
        }
      } else {
        setLoading(false);
      }
    };
    
    initTrips();
  }, []);

  return (
    <TripsContext.Provider value={{ trips, loading, refreshTrips, deleteTrip, addTrip, updateTrip }}>
      {children}
    </TripsContext.Provider>
  );
}

export function useTrips() {
  const context = useContext(TripsContext);
  if (context === undefined) {
    throw new Error('useTrips must be used within a TripsProvider');
  }
  return context;
}
