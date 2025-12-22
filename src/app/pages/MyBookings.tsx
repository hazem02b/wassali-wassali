import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, MapPin, Calendar, Package } from 'lucide-react';
import BottomNav from '../components/BottomNav';

export default function MyBookings() {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'active' | 'completed'>('active');

  const activeBookings = [
    { id: 1, from: 'Tunis', to: 'Paris', date: 'Dec 25', status: 'Confirmed', price: '240€' },
    { id: 2, from: 'Sfax', to: 'Lyon', date: 'Dec 28', status: 'Pending', price: '180€' },
  ];

  const completedBookings = [
    { id: 3, from: 'Tunis', to: 'Marseille', date: 'Dec 15', status: 'Delivered', price: '220€' },
    { id: 4, from: 'Sousse', to: 'Paris', date: 'Dec 10', status: 'Delivered', price: '250€' },
  ];

  const bookings = activeTab === 'active' ? activeBookings : completedBookings;

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate('/home')} className="p-2 hover:bg-gray-100 rounded-full">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl">My Bookings</h1>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white border-b border-gray-200 p-4">
        <div className="flex gap-2">
          <button
            onClick={() => setActiveTab('active')}
            className={`flex-1 py-3 rounded-xl transition-colors ${
              activeTab === 'active' ? 'bg-[#0066FF] text-white' : 'bg-gray-100 text-gray-600'
            }`}
          >
            Active
          </button>
          <button
            onClick={() => setActiveTab('completed')}
            className={`flex-1 py-3 rounded-xl transition-colors ${
              activeTab === 'completed' ? 'bg-[#0066FF] text-white' : 'bg-gray-100 text-gray-600'
            }`}
          >
            Completed
          </button>
        </div>
      </div>

      <div className="p-4 space-y-3">
        {bookings.map((booking) => (
          <div
            key={booking.id}
            onClick={() => navigate('/booking-confirmation')}
            className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 cursor-pointer hover:border-[#0066FF] transition-colors"
          >
            <div className="flex items-start justify-between mb-3">
              <div>
                <div className="flex items-center space-x-2 mb-2">
                  <MapPin className="w-4 h-4 text-gray-400" />
                  <span className="text-sm">{booking.from} → {booking.to}</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Calendar className="w-4 h-4 text-gray-400" />
                  <span className="text-sm text-gray-600">{booking.date}</span>
                </div>
              </div>
              <div className="text-right">
                <span className={`inline-block px-3 py-1 rounded-full text-xs ${
                  booking.status === 'Confirmed' ? 'bg-blue-100 text-blue-700' :
                  booking.status === 'Pending' ? 'bg-yellow-100 text-yellow-700' :
                  'bg-green-100 text-green-700'
                }`}>
                  {booking.status}
                </span>
                <p className="text-lg text-[#0066FF] mt-2">{booking.price}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      <BottomNav active="bookings" />
    </div>
  );
}
