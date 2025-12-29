import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Star } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';

interface Review {
  id: number;
  user: string;
  rating: number;
  comment: string;
  date: string;
}

export default function TransporterReviews() {
  const navigate = useNavigate();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const [reviews, setReviews] = useState<Review[]>([]);
  const [loading, setLoading] = useState(true);
  const [averageRating, setAverageRating] = useState(0);
  const [totalReviews, setTotalReviews] = useState(0);

  useEffect(() => {
    fetchReviews();
  }, []);

  const fetchReviews = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      // TODO: Replace with actual API endpoint when ready
      const response = await fetch('http://localhost:8000/api/v1/reviews/transporter', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.ok) {
        const data = await response.json();
        setReviews(data.reviews || []);
        setAverageRating(data.average_rating || 0);
        setTotalReviews(data.total || 0);
      }
    } catch (err) {
      console.log('Reviews not available yet, using empty state');
      setReviews([]);
    } finally {
      setLoading(false);
    }
  };

  const ratingDistribution = [
    { stars: 5, count: 0, percentage: 0 },
    { stars: 4, count: 0, percentage: 0 },
    { stars: 3, count: 0, percentage: 0 },
    { stars: 2, count: 0, percentage: 0 },
    { stars: 1, count: 0, percentage: 0 },
  ];

  // Calculate distribution from reviews
  if (reviews.length > 0) {
    reviews.forEach(review => {
      const dist = ratingDistribution.find(d => d.stars === review.rating);
      if (dist) dist.count++;
    });
    
    ratingDistribution.forEach(dist => {
      dist.percentage = totalReviews > 0 ? (dist.count / totalReviews) * 100 : 0;
    });
  }

  return (
    <div className={`min-h-screen pb-24 transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      <div className={`border-b p-4 sticky top-0 z-10 ${
        darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
      }`}>
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate('/transporter-dashboard')} className={`p-2 rounded-full ${
            darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
          }`}>
            <ArrowLeft className={`w-6 h-6 ${darkMode ? 'text-white' : ''}`} />
          </button>
          <h1 className={`text-xl ${darkMode ? 'text-white' : ''}`}>{t('myReviews')}</h1>
        </div>
      </div>

      {/* Overall Rating */}
      <div className="bg-gradient-to-r from-[#FF9500] to-[#E68600] text-white p-8 text-center">
        <div className="flex items-center justify-center space-x-2 mb-2">
          <Star className="w-8 h-8 fill-current" />
          <span className="text-4xl">{averageRating.toFixed(1)}</span>
        </div>
        <p className="text-orange-100">{t('rating')}: {totalReviews} {t('reviews')}</p>
      </div>

      {/* Rating Distribution */}
      <div className={`p-6 mb-4 ${
        darkMode ? 'bg-gray-800' : 'bg-white'
      }`}>
        <h2 className={`mb-4 font-semibold ${
          darkMode ? 'text-white' : 'text-gray-900'
        }`}>{t('ratingDistribution')}</h2>
        <div className="space-y-2">
          {ratingDistribution.map((item) => (
            <div key={item.stars} className="flex items-center space-x-3">
              <div className="flex items-center space-x-1 w-16">
                <span className={`text-sm ${darkMode ? 'text-gray-300' : ''}`}>{item.stars}</span>
                <Star className="w-3 h-3 text-yellow-400 fill-current" />
              </div>
              <div className={`flex-1 rounded-full h-2 ${
                darkMode ? 'bg-gray-700' : 'bg-gray-200'
              }`}>
                <div
                  className="bg-[#FF9500] h-2 rounded-full"
                  style={{ width: `${item.percentage}%` }}
                ></div>
              </div>
              <span className={`text-sm w-12 text-right ${
                darkMode ? 'text-gray-400' : 'text-gray-600'
              }`}>{item.count}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Reviews List */}
      <div className="px-6 space-y-4">
        <h2 className={`font-semibold ${
          darkMode ? 'text-white' : 'text-gray-900'
        }`}>{t('recentReviews')}</h2>
        {loading ? (
          <div className="text-center py-8">
            <p className={darkMode ? 'text-gray-400' : 'text-gray-500'}>{t('loading')}</p>
          </div>
        ) : reviews.length > 0 ? (
          <>
            {reviews.map((review) => (
              <div key={review.id} className={`rounded-xl p-4 border ${
                darkMode 
                  ? 'bg-gray-800 border-gray-700' 
                  : 'bg-white border-gray-200'
              }`}>
                <div className="flex items-center justify-between mb-2">
                  <p className={darkMode ? 'text-white' : 'text-gray-900'}>{review.user}</p>
                  <div className="flex items-center space-x-1">
                    {[...Array(review.rating)].map((_, i) => (
                      <Star key={i} className="w-4 h-4 text-yellow-400 fill-current" />
                    ))}
                  </div>
                </div>
                <p className={`text-sm mb-2 ${
                  darkMode ? 'text-gray-300' : 'text-gray-600'
                }`}>{review.comment}</p>
                <p className={`text-xs ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`}>{review.date}</p>
              </div>
            ))}

            <button className={`w-full py-3 border rounded-xl ${
              darkMode 
                ? 'border-gray-600 text-gray-300 hover:bg-gray-800' 
                : 'border-gray-300 text-gray-700 hover:bg-gray-50'
            }`}>
              Load More
            </button>
          </>
        ) : (
          <div className={`text-center py-12 rounded-xl ${
            darkMode ? 'bg-gray-800' : 'bg-white'
          }`}>
            <Star className={`w-16 h-16 mx-auto mb-4 ${
              darkMode ? 'text-gray-600' : 'text-gray-300'
            }`} />
            <p className={`text-sm ${
              darkMode ? 'text-gray-400' : 'text-gray-500'
            }`}>{t('noReviews')}</p>
            <p className={`text-xs mt-2 ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`}>{t('beFirstReview')}</p>
          </div>
        )}
      </div>

      <BottomNav active="reviews" />
    </div>
  );
}
