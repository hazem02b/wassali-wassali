import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Star } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import apiService from '../services/api.service';
import { useLanguage } from '../contexts/LanguageContext';

interface Review {
  id: number;
  rating: number;
  comment: string;
  created_at: string;
  client_id: number;
  booking_id: number;
}

export default function MyReviews() {
  const navigate = useNavigate();
  const { t } = useLanguage();
  const [reviews, setReviews] = useState<Review[]>([]);
  const [loading, setLoading] = useState(true);
  const [averageRating, setAverageRating] = useState(0);

  useEffect(() => {
    fetchReviews();
  }, []);

  const fetchReviews = async () => {
    try {
      setLoading(true);
      const token = localStorage.getItem('token');
      if (!token) {
        navigate('/login');
        return;
      }

      const data = await apiService.getMyReviews(token);
      setReviews(data);
      
      // Calculate average rating
      if (data.length > 0) {
        const avg = data.reduce((sum: number, review: Review) => sum + review.rating, 0) / data.length;
        setAverageRating(Math.round(avg * 10) / 10);
      }
    } catch (err: any) {
      console.error('Error fetching reviews:', err);
      alert('Erreur lors du chargement des avis');
    } finally {
      setLoading(false);
    }
  };

  const renderStars = (rating: number) => {
    return (
      <div className="flex items-center space-x-1">
        {[1, 2, 3, 4, 5].map((star) => (
          <Star
            key={star}
            className={`w-5 h-5 ${
              star <= rating ? 'fill-amber-400 text-amber-400' : 'text-gray-300'
            }`}
          />
        ))}
      </div>
    );
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
      day: 'numeric',
      month: 'long',
      year: 'numeric'
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#0066FF]"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <div className="flex items-center">
          <button
            onClick={() => navigate('/transporter-dashboard')}
            className="p-2 hover:bg-gray-100 rounded-full"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-bold ml-3">{t('myReviews')}</h1>
        </div>
      </div>

      {/* Average Rating */}
      {reviews.length > 0 && (
        <div className="bg-gradient-to-r from-amber-500 to-orange-500 p-6 text-white">
          <div className="text-center">
            <p className="text-sm opacity-90 mb-2">{t('averageRating')}</p>
            <div className="flex items-center justify-center space-x-3 mb-3">
              <span className="text-5xl font-bold">{averageRating}</span>
              <div>
                {renderStars(Math.round(averageRating))}
                <p className="text-sm opacity-90 mt-1">{reviews.length} {t('reviews')}</p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Reviews List */}
      <div className="p-4 space-y-3">
        {reviews.length === 0 ? (
          <div className="bg-white rounded-xl p-8 text-center">
            <Star className="w-16 h-16 text-gray-300 mx-auto mb-3" />
            <p className="text-gray-500 mb-2">{t('noReviewsYet')}</p>
            <p className="text-sm text-gray-400">
              {t('reviewsFromClients')}
            </p>
          </div>
        ) : (
          reviews.map((review) => (
            <div
              key={review.id}
              className="bg-white rounded-xl p-4 shadow-sm border border-gray-100"
            >
              {/* Rating and Date */}
              <div className="flex items-center justify-between mb-3">
                {renderStars(review.rating)}
                <span className="text-xs text-gray-500">
                  {formatDate(review.created_at)}
                </span>
              </div>

              {/* Comment */}
              {review.comment && (
                <p className="text-gray-700 text-sm leading-relaxed">
                  "{review.comment}"
                </p>
              )}

              {/* Booking Reference */}
              <div className="mt-3 pt-3 border-t border-gray-100">
                <p className="text-xs text-gray-500">
                  {t('reservation')} #{review.booking_id}
                </p>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Info Card */}
      <div className="px-4 pb-4">
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
          <p className="text-xs text-blue-700">
            💡 <strong>{t('reviewTip')}</strong><br />
            {t('positiveReviewsTip')}
          </p>
        </div>
      </div>

      <BottomNav active="reviews" />
    </div>
  );
}
