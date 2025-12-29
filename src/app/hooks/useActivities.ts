import { useState, useEffect } from 'react';

export interface Activity {
  id: number;
  text: string;
  time: string;
  type: 'booking' | 'completed' | 'review' | 'message' | 'payment';
  icon?: string;
}

export function useActivities(userId?: number) {
  const [activities, setActivities] = useState<Activity[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (userId) {
      fetchActivities();
    } else {
      setLoading(false);
    }
  }, [userId]);

  const fetchActivities = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Replace with real API call when backend is ready
      // const response = await apiService.get('/activities');
      // setActivities(response.data);
      
      // For now, return empty array
      setActivities([]);
      
    } catch (err) {
      console.error('Error fetching activities:', err);
      setError('Failed to load activities');
      setActivities([]);
    } finally {
      setLoading(false);
    }
  };

  return {
    activities,
    loading,
    error,
    refetch: fetchActivities,
  };
}
