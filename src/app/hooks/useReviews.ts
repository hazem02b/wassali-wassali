import { useState, useEffect } from 'react';

export interface Review {
  id: number;
  user: string;
  rating: number;
  comment: string;
  date: string;
  avatar?: string;
}

export function useReviews(transporterId?: number) {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [averageRating, setAverageRating] = useState(0);

  useEffect(() => {
    if (transporterId) {
      fetchReviews();
    } else {
      setLoading(false);
    }
  }, [transporterId]);

  const fetchReviews = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Replace with real API call when backend is ready
      // const response = await apiService.get(`/transporters/${transporterId}/reviews`);
      // setReviews(response.data.reviews);
      // setAverageRating(response.data.average_rating);
      
      // For now, return empty array
      setReviews([]);
      setAverageRating(0);
      
    } catch (err) {
      console.error('Error fetching reviews:', err);
      setError('Failed to load reviews');
      setReviews([]);
    } finally {
      setLoading(false);
    }
  };

  const addReview = async (rating: number, comment: string) => {
    try {
      // await apiService.post(`/transporters/${transporterId}/reviews`, { rating, comment });
      await fetchReviews();
    } catch (err) {
      console.error('Error adding review:', err);
      throw err;
    }
  };

  return {
    reviews,
    loading,
    error,
    averageRating,
    refetch: fetchReviews,
    addReview,
  };
}
