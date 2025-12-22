import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Star, MapPin, Clock, Package, SlidersHorizontal, CheckCircle } from 'lucide-react';
import BottomNav from '../components/BottomNav';

export default function SearchResults() {
  const navigate = useNavigate();

  const transporters = [
    {
      id: 1,
      name: 'Mohamed Ali',
      avatar: '👨',
      verified: true,
      rating: 4.8,
      reviews: 156,
      from: 'Tunis',
      to: 'Paris',
      date: 'Dec 25',
      time: '10:00 AM',
      price: 45,
      capacity: 70,
    },
    {
      id: 2,
      name: 'Sarah Ben',
      avatar: '👩',
      verified: true,
      rating: 4.9,
      reviews: 203,
      from: 'Tunis',
      to: 'Paris',
      date: 'Dec 26',
      time: '2:00 PM',
      price: 40,
      capacity: 45,
    },
    {
      id: 3,
      name: 'Ahmed Trabelsi',
      avatar: '👨',
      verified: false,
      rating: 4.5,
      reviews: 89,
      from: 'Tunis',
      to: 'Paris',
      date: 'Dec 27',
      time: '8:00 AM',
      price: 50,
      capacity: 90,
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <div className="flex items-center space-x-3">
          <button
            onClick={() => navigate('/home')}
            className="p-2 hover:bg-gray-100 rounded-full"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex-1">
            <p className="text-sm text-gray-600">Tunis → Paris</p>
            <p className="text-xs text-gray-400">Dec 25, 2024</p>
          </div>
          <button className="p-2 hover:bg-gray-100 rounded-full">
            <SlidersHorizontal className="w-6 h-6" />
          </button>
        </div>
      </div>

      {/* Results Count */}
      <div className="p-4 bg-blue-50 border-b border-blue-100">
        <p className="text-sm text-gray-700">
          <span>{transporters.length} transporters</span> found for your search
        </p>
      </div>

      {/* Transport Offers */}
      <div className="p-4 space-y-3">
        {transporters.map((transporter) => (
          <div
            key={transporter.id}
            className="bg-white rounded-xl p-4 shadow-sm border border-gray-100"
          >
            {/* Transporter Info */}
            <div className="flex items-start justify-between mb-3">
              <div className="flex items-center space-x-3">
                <div className="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center text-xl">
                  {transporter.avatar}
                </div>
                <div>
                  <div className="flex items-center space-x-1">
                    <p>{transporter.name}</p>
                    {transporter.verified && (
                      <CheckCircle className="w-4 h-4 text-blue-500 fill-current" />
                    )}
                  </div>
                  <div className="flex items-center space-x-1 text-xs text-gray-500">
                    <Star className="w-3 h-3 text-yellow-400 fill-current" />
                    <span>{transporter.rating}</span>
                    <span>({transporter.reviews})</span>
                  </div>
                </div>
              </div>
              <div className="text-right">
                <p className="text-lg text-[#0066FF]">{transporter.price}€</p>
                <p className="text-xs text-gray-500">per kg</p>
              </div>
            </div>

            {/* Route Info */}
            <div className="flex items-center space-x-2 text-sm text-gray-600 mb-2">
              <MapPin className="w-4 h-4" />
              <span>{transporter.from} → {transporter.to}</span>
            </div>

            <div className="flex items-center space-x-2 text-sm text-gray-600 mb-3">
              <Clock className="w-4 h-4" />
              <span>{transporter.date} at {transporter.time}</span>
            </div>

            {/* Capacity Bar */}
            <div className="mb-3">
              <div className="flex items-center justify-between text-xs text-gray-500 mb-1">
                <span>Capacity</span>
                <span>{transporter.capacity}%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className="bg-[#0066FF] h-2 rounded-full transition-all"
                  style={{ width: `${transporter.capacity}%` }}
                ></div>
              </div>
            </div>

            {/* Actions */}
            <div className="flex gap-2">
              <button
                onClick={() => navigate(`/transport/${transporter.id}`)}
                className="flex-1 py-2 border border-[#0066FF] text-[#0066FF] rounded-lg transition-colors hover:bg-blue-50"
              >
                Details
              </button>
              <button
                onClick={() => navigate(`/booking/${transporter.id}`)}
                className="flex-1 py-2 bg-[#0066FF] text-white rounded-lg transition-all active:scale-98"
              >
                Book
              </button>
            </div>
          </div>
        ))}
      </div>

      <BottomNav active="search" />
    </div>
  );
}
