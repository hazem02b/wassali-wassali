import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Star, Phone, MessageCircle, MapPin, Clock, Package, CheckCircle2, Shield } from 'lucide-react';
import BottomNav from '../components/BottomNav';

export default function TransportDetails() {
  const navigate = useNavigate();
  const { id } = useParams();

  const transporter = {
    name: 'Mohamed Ali',
    avatar: '👨',
    verified: true,
    rating: 4.8,
    reviews: 156,
    phone: '+216 XX XXX XXX',
    from: 'Tunis',
    to: 'Paris',
    date: 'Dec 25, 2024',
    time: '10:00 AM',
    price: 45,
    capacity: 70,
    availableWeight: '15kg',
    transportableItems: ['Documents', 'Clothes', 'Electronics', 'Food (non-perishable)', 'Books'],
  };

  const reviews = [
    { id: 1, user: 'Fatma K.', rating: 5, comment: 'Very professional and fast delivery!', date: '2 days ago' },
    { id: 2, user: 'Ali M.', rating: 4, comment: 'Good service, package arrived safely', date: '1 week ago' },
    { id: 3, user: 'Leila S.', rating: 5, comment: 'Excellent communication throughout', date: '2 weeks ago' },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-32">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <button
          onClick={() => navigate('/search')}
          className="p-2 hover:bg-gray-100 rounded-full inline-flex"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
      </div>

      {/* Transporter Profile */}
      <div className="bg-white p-6 mb-4">
        <div className="flex items-center space-x-4 mb-4">
          <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center text-3xl">
            {transporter.avatar}
          </div>
          <div className="flex-1">
            <div className="flex items-center space-x-2 mb-1">
              <h1 className="text-xl">{transporter.name}</h1>
              {transporter.verified && (
                <CheckCircle2 className="w-5 h-5 text-blue-500 fill-current" />
              )}
            </div>
            <div className="flex items-center space-x-1 text-sm">
              <Star className="w-4 h-4 text-yellow-400 fill-current" />
              <span>{transporter.rating}</span>
              <span className="text-gray-500">({transporter.reviews} reviews)</span>
            </div>
          </div>
        </div>

        {/* Contact Buttons */}
        <div className="flex gap-3">
          <button className="flex-1 flex items-center justify-center space-x-2 py-3 border border-gray-200 rounded-xl hover:bg-gray-50">
            <Phone className="w-5 h-5" />
            <span>Call</span>
          </button>
          <button className="flex-1 flex items-center justify-center space-x-2 py-3 border border-gray-200 rounded-xl hover:bg-gray-50">
            <MessageCircle className="w-5 h-5" />
            <span>Message</span>
          </button>
        </div>
      </div>

      {/* Route & Time Info */}
      <div className="bg-white p-6 mb-4">
        <h2 className="mb-4">Trip Details</h2>
        <div className="space-y-3">
          <div className="flex items-center space-x-3">
            <MapPin className="w-5 h-5 text-gray-400" />
            <div>
              <p className="text-sm text-gray-500">Route</p>
              <p>{transporter.from} → {transporter.to}</p>
            </div>
          </div>
          <div className="flex items-center space-x-3">
            <Clock className="w-5 h-5 text-gray-400" />
            <div>
              <p className="text-sm text-gray-500">Departure</p>
              <p>{transporter.date} at {transporter.time}</p>
            </div>
          </div>
          <div className="flex items-center space-x-3">
            <Package className="w-5 h-5 text-gray-400" />
            <div>
              <p className="text-sm text-gray-500">Available Capacity</p>
              <p>{transporter.availableWeight}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Pricing */}
      <div className="bg-white p-6 mb-4">
        <h2 className="mb-4">Pricing</h2>
        <div className="flex items-center justify-between">
          <span className="text-gray-600">Price per kg</span>
          <span className="text-2xl text-[#0066FF]">{transporter.price}€</span>
        </div>
      </div>

      {/* Transportable Items */}
      <div className="bg-white p-6 mb-4">
        <h2 className="mb-4">Items Transportable</h2>
        <div className="grid grid-cols-2 gap-2">
          {transporter.transportableItems.map((item, index) => (
            <div key={index} className="flex items-center space-x-2">
              <CheckCircle2 className="w-4 h-4 text-green-500" />
              <span className="text-sm">{item}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Reviews */}
      <div className="bg-white p-6 mb-4">
        <h2 className="mb-4">Reviews</h2>
        <div className="space-y-4">
          {reviews.map((review) => (
            <div key={review.id} className="border-b border-gray-100 last:border-0 pb-4 last:pb-0">
              <div className="flex items-center justify-between mb-2">
                <p>{review.user}</p>
                <div className="flex items-center space-x-1">
                  {[...Array(review.rating)].map((_, i) => (
                    <Star key={i} className="w-3 h-3 text-yellow-400 fill-current" />
                  ))}
                </div>
              </div>
              <p className="text-sm text-gray-600 mb-1">{review.comment}</p>
              <p className="text-xs text-gray-400">{review.date}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Fixed Bottom Button */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 safe-area-bottom max-w-[390px] mx-auto">
        <button
          onClick={() => navigate(`/booking/${id}`)}
          className="w-full bg-[#0066FF] text-white py-4 rounded-xl transition-all active:scale-98"
        >
          Book this transport
        </button>
      </div>

      <BottomNav active="search" />
    </div>
  );
}
