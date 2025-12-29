import { createContext, useContext, useState, ReactNode } from 'react';

export interface Booking {
  id: string;
  transporterId: string;
  transporterName: string;
  from: string;
  to: string;
  date: string;
  time: string;
  weight: number;
  pricePerKg: number;
  totalPrice: number;
  status: 'pending' | 'confirmed' | 'in-transit' | 'delivered' | 'cancelled';
  packageDescription: string;
  pickupAddress: string;
  deliveryAddress: string;
  specialNotes?: string;
  createdAt: string;
}

interface BookingContextType {
  bookings: Booking[];
  currentBooking: Partial<Booking> | null;
  addBooking: (booking: Booking) => void;
  updateBooking: (id: string, updates: Partial<Booking>) => void;
  cancelBooking: (id: string) => void;
  setCurrentBooking: (booking: Partial<Booking> | null) => void;
  getBookingById: (id: string) => Booking | undefined;
}

const BookingContext = createContext<BookingContextType | undefined>(undefined);

export function BookingProvider({ children }: { children: ReactNode }) {
  const [bookings, setBookings] = useState<Booking[]>([
    {
      id: '1',
      transporterId: '1',
      transporterName: 'Mohamed Ali',
      from: 'Tunis',
      to: 'Paris',
      date: 'Dec 25, 2024',
      time: '10:00 AM',
      weight: 5,
      pricePerKg: 45,
      totalPrice: 240,
      status: 'confirmed',
      packageDescription: 'Documents and books',
      pickupAddress: '123 Ave Habib Bourguiba, Tunis',
      deliveryAddress: '45 Rue de la Paix, Paris',
      createdAt: new Date().toISOString(),
    },
    {
      id: '2',
      transporterId: '2',
      transporterName: 'Sarah Ben',
      from: 'Sfax',
      to: 'Lyon',
      date: 'Dec 28, 2024',
      time: '2:00 PM',
      weight: 3,
      pricePerKg: 40,
      totalPrice: 180,
      status: 'pending',
      packageDescription: 'Clothes',
      pickupAddress: '78 Ave de la Liberté, Sfax',
      deliveryAddress: '12 Place Bellecour, Lyon',
      createdAt: new Date().toISOString(),
    },
  ]);
  
  const [currentBooking, setCurrentBooking] = useState<Partial<Booking> | null>(null);

  const addBooking = (booking: Booking) => {
    setBookings(prev => [...prev, booking]);
  };

  const updateBooking = (id: string, updates: Partial<Booking>) => {
    setBookings(prev => prev.map(booking => 
      booking.id === id ? { ...booking, ...updates } : booking
    ));
  };

  const cancelBooking = (id: string) => {
    updateBooking(id, { status: 'cancelled' });
  };

  const getBookingById = (id: string) => {
    return bookings.find(booking => booking.id === id);
  };

  return (
    <BookingContext.Provider value={{
      bookings,
      currentBooking,
      addBooking,
      updateBooking,
      cancelBooking,
      setCurrentBooking,
      getBookingById,
    }}>
      {children}
    </BookingContext.Provider>
  );
}

export function useBooking() {
  const context = useContext(BookingContext);
  if (context === undefined) {
    throw new Error('useBooking must be used within a BookingProvider');
  }
  return context;
}
