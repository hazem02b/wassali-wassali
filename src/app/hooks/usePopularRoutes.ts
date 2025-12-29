import { useState, useEffect } from 'react';
import { STORAGE_KEYS } from '../constants';

export interface PopularRoute {
  id: string;
  from: string;
  to: string;
  count: number;
  price: string;
}

const DEFAULT_ROUTES: PopularRoute[] = [
  { id: '1', from: 'Tunis', to: 'Paris', count: 245, price: '45€' },
  { id: '2', from: 'Sfax', to: 'Lyon', count: 189, price: '40€' },
  { id: '3', from: 'Sousse', to: 'Marseille', count: 167, price: '42€' },
  { id: '4', from: 'Monastir', to: 'Nice', count: 134, price: '48€' },
];

export function usePopularRoutes() {
  const [routes, setRoutes] = useState<PopularRoute[]>(DEFAULT_ROUTES);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchPopularRoutes();
  }, []);

  const fetchPopularRoutes = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Replace with real API call when backend is ready
      // const response = await apiService.get('/routes/popular');
      // setRoutes(response.data);
      
      // For now, check localStorage for dynamic data or use defaults
      try {
        const stored = localStorage.getItem(STORAGE_KEYS.RECENT_SEARCHES);
        if (stored) {
          const searches = JSON.parse(stored);
          // Could aggregate searches to show most popular routes
          // For now, just use defaults
        }
      } catch (e) {
        console.error('Error loading from localStorage:', e);
      }
      
      setRoutes(DEFAULT_ROUTES);
      
    } catch (err) {
      console.error('Error fetching popular routes:', err);
      setError('Failed to load popular routes');
      setRoutes(DEFAULT_ROUTES);
    } finally {
      setLoading(false);
    }
  };

  return {
    routes,
    loading,
    error,
    refetch: fetchPopularRoutes,
  };
}
