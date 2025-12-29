import { useState, useEffect } from 'react';

export interface Stats {
  totalTrips: number;
  activeBookings: number;
  monthlyRevenue: number;
  completedTrips: number;
  pendingRequests: number;
  totalReviews: number;
  averageRating: number;
}

export function useStats(userId?: number) {
  const [stats, setStats] = useState<Stats>({
    totalTrips: 0,
    activeBookings: 0,
    monthlyRevenue: 0,
    completedTrips: 0,
    pendingRequests: 0,
    totalReviews: 0,
    averageRating: 0,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (userId) {
      fetchStats();
    } else {
      setLoading(false);
    }
  }, [userId]);

  const fetchStats = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Replace with real API call when backend is ready
      // const response = await apiService.get('/stats');
      // setStats(response.data);
      
      // For now, return default values
      setStats({
        totalTrips: 0,
        activeBookings: 0,
        monthlyRevenue: 0,
        completedTrips: 0,
        pendingRequests: 0,
        totalReviews: 0,
        averageRating: 0,
      });
      
    } catch (err) {
      console.error('Error fetching stats:', err);
      setError('Failed to load stats');
    } finally {
      setLoading(false);
    }
  };

  return {
    stats,
    loading,
    error,
    refetch: fetchStats,
  };
}
