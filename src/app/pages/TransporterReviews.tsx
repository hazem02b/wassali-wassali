import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Star } from 'lucide-react';

export default function TransporterReviews() {
  const navigate = useNavigate();

  const reviews = [
    { id: 1, user: 'Fatma K.', rating: 5, comment: 'Very professional and fast delivery!', date: '2 days ago' },
    { id: 2, user: 'Ali M.', rating: 4, comment: 'Good service, package arrived safely', date: '1 week ago' },
    { id: 3, user: 'Leila S.', rating: 5, comment: 'Excellent communication throughout', date: '2 weeks ago' },
    { id: 4, user: 'Ahmed B.', rating: 5, comment: 'Highly recommend! Will use again', date: '3 weeks ago' },
    { id: 5, user: 'Sarah H.', rating: 4, comment: 'Reliable transporter', date: '1 month ago' },
  ];

  const ratingDistribution = [
    { stars: 5, count: 120, percentage: 75 },
    { stars: 4, count: 30, percentage: 19 },
    { stars: 3, count: 6, percentage: 4 },
    { stars: 2, count: 2, percentage: 1 },
    { stars: 1, count: 2, percentage: 1 },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-6">
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate('/transporter-dashboard')} className="p-2 hover:bg-gray-100 rounded-full">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl">My Reviews</h1>
        </div>
      </div>

      {/* Overall Rating */}
      <div className="bg-gradient-to-r from-[#FF9500] to-[#E68600] text-white p-8 text-center">
        <div className="flex items-center justify-center space-x-2 mb-2">
          <Star className="w-8 h-8 fill-current" />
          <span className="text-4xl">4.8</span>
        </div>
        <p className="text-orange-100">Based on 160 reviews</p>
      </div>

      {/* Rating Distribution */}
      <div className="bg-white p-6 mb-4">
        <h2 className="mb-4">Rating Distribution</h2>
        <div className="space-y-2">
          {ratingDistribution.map((item) => (
            <div key={item.stars} className="flex items-center space-x-3">
              <div className="flex items-center space-x-1 w-16">
                <span className="text-sm">{item.stars}</span>
                <Star className="w-3 h-3 text-yellow-400 fill-current" />
              </div>
              <div className="flex-1 bg-gray-200 rounded-full h-2">
                <div
                  className="bg-[#FF9500] h-2 rounded-full"
                  style={{ width: `${item.percentage}%` }}
                ></div>
              </div>
              <span className="text-sm text-gray-600 w-12 text-right">{item.count}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Reviews List */}
      <div className="px-6 space-y-4">
        <h2>Recent Reviews</h2>
        {reviews.map((review) => (
          <div key={review.id} className="bg-white rounded-xl p-4 border border-gray-200">
            <div className="flex items-center justify-between mb-2">
              <p>{review.user}</p>
              <div className="flex items-center space-x-1">
                {[...Array(review.rating)].map((_, i) => (
                  <Star key={i} className="w-4 h-4 text-yellow-400 fill-current" />
                ))}
              </div>
            </div>
            <p className="text-sm text-gray-600 mb-2">{review.comment}</p>
            <p className="text-xs text-gray-400">{review.date}</p>
          </div>
        ))}

        <button className="w-full py-3 border border-gray-300 text-gray-700 rounded-xl">
          Load More
        </button>
      </div>
    </div>
  );
}
