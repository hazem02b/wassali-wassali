import { useNavigate } from 'react-router-dom';
import { Plus, TrendingUp, Calendar, DollarSign, Package, Star, Clock } from 'lucide-react';
import LanguageSelector from '../components/LanguageSelector';

export default function TransporterDashboard() {
  const navigate = useNavigate();

  const stats = [
    { label: 'Active Trips', value: '3', icon: Package, color: 'bg-blue-100 text-blue-600' },
    { label: 'Pending Bookings', value: '5', icon: Calendar, color: 'bg-yellow-100 text-yellow-600' },
    { label: 'Monthly Revenue', value: '2,450€', icon: DollarSign, color: 'bg-green-100 text-green-600' },
  ];

  const pendingBookings = [
    { id: 1, client: 'Fatma K.', route: 'Tunis → Paris', weight: '5kg', price: '225€' },
    { id: 2, client: 'Ali M.', route: 'Sfax → Lyon', weight: '3kg', price: '135€' },
  ];

  const recentActivities = [
    { id: 1, text: 'New booking from Fatma K.', time: '5 min ago', type: 'booking' },
    { id: 2, text: 'Trip to Paris completed', time: '2 hours ago', type: 'completed' },
    { id: 3, text: 'New review received (5⭐)', time: '1 day ago', type: 'review' },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-[#FF9500] to-[#E68600] text-white p-6 rounded-b-3xl mb-6">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl mb-1">Welcome, Mohamed</h1>
            <p className="text-orange-100">Ready to transport today?</p>
          </div>
          <div className="flex items-center space-x-2">
            <LanguageSelector />
            <button 
              onClick={() => navigate('/profile')}
              className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center"
            >
              <span className="text-xl">👤</span>
            </button>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-3">
          {stats.map((stat, index) => (
            <div key={index} className="bg-white/10 backdrop-blur rounded-xl p-3 text-center">
              <div className={`w-8 h-8 ${stat.color} rounded-lg flex items-center justify-center mx-auto mb-2`}>
                <stat.icon className="w-5 h-5" />
              </div>
              <p className="text-lg">{stat.value}</p>
              <p className="text-xs text-orange-100">{stat.label}</p>
            </div>
          ))}
        </div>
      </div>

      <div className="px-6 space-y-6">
        {/* Next Trip */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center justify-between mb-3">
            <h2>Next Trip</h2>
            <button className="text-sm text-[#FF9500]">Edit</button>
          </div>
          <div className="space-y-2">
            <div className="flex items-center space-x-2">
              <Package className="w-4 h-4 text-gray-400" />
              <span className="text-sm">Tunis → Paris</span>
            </div>
            <div className="flex items-center space-x-2">
              <Clock className="w-4 h-4 text-gray-400" />
              <span className="text-sm text-gray-600">Dec 25 at 10:00 AM</span>
            </div>
            <div className="flex items-center space-x-2">
              <TrendingUp className="w-4 h-4 text-gray-400" />
              <span className="text-sm text-gray-600">Capacity: 70%</span>
            </div>
          </div>
          <button
            onClick={() => navigate('/my-trips')}
            className="w-full mt-4 py-2 bg-orange-50 text-[#FF9500] rounded-lg text-sm"
          >
            View Details
          </button>
        </div>

        {/* Pending Bookings */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h2 className="mb-3">Pending Bookings</h2>
          <div className="space-y-3">
            {pendingBookings.map((booking) => (
              <div key={booking.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="text-sm mb-1">{booking.client}</p>
                  <p className="text-xs text-gray-500">{booking.route} • {booking.weight}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm text-[#FF9500]">{booking.price}</p>
                  <div className="flex gap-1 mt-1">
                    <button className="text-xs px-2 py-1 bg-green-100 text-green-700 rounded">Accept</button>
                    <button className="text-xs px-2 py-1 bg-red-100 text-red-700 rounded">Decline</button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Activities */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h2 className="mb-3">Recent Activities</h2>
          <div className="space-y-3">
            {recentActivities.map((activity) => (
              <div key={activity.id} className="flex items-start space-x-3">
                <div className={`w-2 h-2 rounded-full mt-2 ${
                  activity.type === 'booking' ? 'bg-blue-500' :
                  activity.type === 'completed' ? 'bg-green-500' :
                  'bg-yellow-500'
                }`}></div>
                <div className="flex-1">
                  <p className="text-sm">{activity.text}</p>
                  <p className="text-xs text-gray-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Action Buttons */}
        <div className="grid grid-cols-2 gap-3">
          <button
            onClick={() => navigate('/create-trip')}
            className="flex items-center justify-center space-x-2 bg-[#FF9500] text-white py-4 rounded-xl"
          >
            <Plus className="w-5 h-5" />
            <span>Post New Trip</span>
          </button>
          <button
            onClick={() => navigate('/transporter-reviews')}
            className="flex items-center justify-center space-x-2 border border-gray-300 text-gray-700 py-4 rounded-xl"
          >
            <Star className="w-5 h-5" />
            <span>My Reviews</span>
          </button>
        </div>
      </div>
    </div>
  );
}