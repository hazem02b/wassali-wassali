import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, TrendingUp, Calendar, DollarSign, Package, Star, Clock } from 'lucide-react';
import LanguageSelector from '../components/LanguageSelector';
import UserAvatar from '../components/UserAvatar';
import BottomNav from '../components/BottomNav';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';
import { useTrips } from '../contexts/TripsContext';
import apiService from '../services/api.service';

interface Trip {
  id: number;
  origin_city: string;
  destination_city: string;
  departure_date: string;
  max_weight: number;
  available_weight: number;
  price_per_kg: number;
}

interface Booking {
  id: number;
  trip_id: number;
  weight: number;
  total_price: number;
  status: string;
  is_paid: boolean;
  created_at: string;
  client: {
    name: string;
  };
  trip: {
    origin_city: string;
    destination_city: string;
  };
}

export default function TransporterDashboard() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const { trips, loading: tripsLoading } = useTrips();
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  // Check if user is transporter, redirect if not
  useEffect(() => {
    if (user && user.type !== 'transporter') {
      navigate('/home');
    }
  }, [user, navigate]);

  const fetchDashboardData = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      // Only fetch bookings, trips come from context
      const bookingsData = await apiService.getMyBookings(token);
      console.log('📦 Bookings received for transporter:', bookingsData);
      // Ensure is_paid is always defined
      const bookingsWithPaidStatus = bookingsData.map((booking: any) => ({
        ...booking,
        is_paid: booking.is_paid === true
      }));
      setBookings(bookingsWithPaidStatus);
    } catch (err) {
      console.error('Error fetching dashboard data:', err);
    } finally {
      setLoading(false);
    }
  };

  // Calculate stats from real data
  const now = new Date();
  const activeTrips = trips.filter(t => new Date(t.departure_date) >= now);
  const pendingBookingsList = bookings.filter(b => b.status.toLowerCase() === 'pending');
  const monthlyRevenue = bookings
    .filter(b => {
      const bookingDate = new Date(b.created_at);
      const monthAgo = new Date();
      monthAgo.setMonth(monthAgo.getMonth() - 1);
      return bookingDate >= monthAgo && b.status !== 'cancelled';
    })
    .reduce((sum, b) => sum + b.total_price, 0);

  const stats = [
    { label: t('activeTrips'), value: (tripsLoading || loading) ? '...' : activeTrips.length.toString(), icon: Package, color: 'bg-blue-100 text-blue-600' },
    { label: t('pendingBookings'), value: loading ? '...' : pendingBookingsList.length.toString(), icon: Calendar, color: 'bg-yellow-100 text-yellow-600' },
    { label: t('monthlyRevenue'), value: loading ? '...' : `${monthlyRevenue.toFixed(0)}€`, icon: DollarSign, color: 'bg-green-100 text-green-600' },
  ];

  const handleAcceptBooking = async (bookingId: number) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      await apiService.updateBooking(bookingId, { status: 'confirmed' }, token);
      
      // Refresh bookings
      await fetchDashboardData();
      alert('Booking accepted! Client will be notified.');
    } catch (err) {
      console.error('Error accepting booking:', err);
      alert('Error accepting booking');
    }
  };

  const handleRejectBooking = async (bookingId: number) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      await apiService.updateBooking(bookingId, { status: 'cancelled' }, token);
      
      // Refresh bookings
      await fetchDashboardData();
      alert('Booking rejected! Client will be notified.');
    } catch (err) {
      console.error('Error rejecting booking:', err);
      alert('Error rejecting booking');
    }
  };

  const handleMarkAsDelivered = async (bookingId: number) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      await apiService.updateBooking(bookingId, { status: 'delivered' }, token);
      
      // Refresh bookings
      await fetchDashboardData();
      alert('✅ Livraison confirmée ! Le client peut maintenant laisser un avis.');
    } catch (err) {
      console.error('Error marking as delivered:', err);
      alert('Error updating delivery status');
    }
  };
  const handleStartDelivery = async (bookingId: number) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      await apiService.updateBooking(bookingId, { status: 'in_transit' }, token);
      
      // Refresh dashboard
      await fetchDashboardData();
      alert('🚚 Livraison commencée !');
    } catch (err) {
      console.error('Error starting delivery:', err);
      alert('Error starting delivery');
    }
  };
  const pendingBookings = pendingBookingsList.slice(0, 5).map(b => ({
    id: b.id,
    client: b.client?.name || 'Unknown',
    route: `${b.trip?.origin_city || 'Unknown'} → ${b.trip?.destination_city || 'Unknown'}`,
    weight: `${b.weight}kg`,
    price: `${b.total_price.toFixed(2)}€`
  }));

  // Get confirmed and paid bookings ready for delivery
  const confirmedPaidBookings = bookings
    .filter(b => b.status.toLowerCase() === 'confirmed' && b.is_paid === true)
    .slice(0, 5)
    .map(b => ({
      id: b.id,
      client: b.client?.name || 'Unknown',
      route: `${b.trip?.origin_city || 'Unknown'} → ${b.trip?.destination_city || 'Unknown'}`,
      weight: `${b.weight}kg`,
      price: `${b.total_price.toFixed(2)}€`
    }));

  // Get in-transit bookings
  const inTransitBookings = bookings
    .filter(b => b.status.toLowerCase() === 'in_transit')
    .slice(0, 5)
    .map(b => ({
      id: b.id,
      client: b.client?.name || 'Unknown',
      route: `${b.trip?.origin_city || 'Unknown'} → ${b.trip?.destination_city || 'Unknown'}`,
      weight: `${b.weight}kg`,
      price: `${b.total_price.toFixed(2)}€`
    }));

  // Recent activities from bookings
  const recentActivities = bookings
    .slice(0, 5)
    .map(b => ({
      id: b.id,
      type: b.status.toLowerCase() === 'pending' ? 'new_booking' : 
            b.status.toLowerCase() === 'confirmed' && b.is_paid ? 'payment_received' :
            b.status.toLowerCase() === 'in_transit' ? 'delivery_started' :
            b.status.toLowerCase() === 'delivered' ? 'delivery_completed' : 'booking_update',
      client: b.client?.name || 'Unknown',
      route: `${b.trip?.origin_city || 'Unknown'} → ${b.trip?.destination_city || 'Unknown'}`,
      time: new Date(b.created_at).toLocaleDateString('fr-FR', { 
        month: 'short', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      }),
      status: b.status
    }));

  return (
    <div className={`min-h-screen pb-20 ${darkMode ? 'bg-gray-900' : 'bg-gray-50'}`}>
      {/* Header */}
      <div className="bg-gradient-to-r from-[#FF9500] to-[#E68600] text-white p-6 rounded-b-3xl mb-6">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl mb-1">{t('welcomeTransporter')}, {user?.name || 'Transporter'}</h1>
            <p className="text-orange-100">{t('readyToTransport')}</p>
          </div>
          <div className="flex items-center space-x-2">
            <LanguageSelector />
            <button 
              onClick={() => navigate('/transporter-profile')}
              className="hover:opacity-80 transition-opacity"
            >
              <UserAvatar user={user} size="md" />
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
        {activeTrips.length > 0 ? (
          <div className={`rounded-xl p-4 border ${
            darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
          }`}>
            <div className="flex items-center justify-between mb-3">
              <h2 className={`font-semibold ${darkMode ? 'text-white' : 'text-gray-900'}`}>{t('nextTrip')}</h2>
            </div>
            <div className="space-y-2">
              <div className="flex items-center space-x-2">
                <Package className={`w-4 h-4 ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`} />
                <span className={`text-sm ${
                  darkMode ? 'text-gray-300' : 'text-gray-900'
                }`}>{activeTrips[0].origin_city} → {activeTrips[0].destination_city}</span>
              </div>
              <div className="flex items-center space-x-2">
                <Clock className={`w-4 h-4 ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`} />
                <span className={`text-sm ${
                  darkMode ? 'text-gray-400' : 'text-gray-600'
                }`}>{new Date(activeTrips[0].departure_date).toLocaleString()}</span>
              </div>
              <div className="flex items-center space-x-2">
                <TrendingUp className={`w-4 h-4 ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`} />
                <span className={`text-sm ${
                  darkMode ? 'text-gray-400' : 'text-gray-600'
                }`}>{t('capacity')}: {Math.round((1 - activeTrips[0].available_weight / activeTrips[0].max_weight) * 100)}%</span>
              </div>
            </div>
            <button
              onClick={() => navigate('/my-trips')}
              className={`w-full mt-4 py-2 rounded-lg text-sm ${
                darkMode 
                  ? 'bg-orange-900/30 text-[#FF9500]' 
                  : 'bg-orange-50 text-[#FF9500]'
              }`}
            >
              {t('viewDetails')}
            </button>
          </div>
        ) : (
          <div className={`rounded-xl p-6 border text-center ${
            darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
          }`}>
            <Package className={`w-12 h-12 mx-auto mb-3 ${
              darkMode ? 'text-gray-600' : 'text-gray-300'
            }`} />
            <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
              {t('noActiveTrips')}
            </p>
          </div>
        )}

        {/* Confirmed & Paid Bookings */}
        <div className={`rounded-xl p-4 border mb-4 ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`mb-3 font-semibold ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>💰 {t('confirmedBookings')}</h2>
          <div className="space-y-3">
            {confirmedPaidBookings.length > 0 ? confirmedPaidBookings.map((booking) => (
              <div key={booking.id} className={`flex items-center justify-between p-3 rounded-lg ${
                darkMode ? 'bg-gray-700' : 'bg-gray-50'
              }`}>
                <div>
                  <p className={`text-sm mb-1 ${
                    darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{booking.client}</p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-400' : 'text-gray-500'
                  }`}>{booking.route} • {booking.weight}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm text-[#FF9500]">{booking.price}</p>
                  <button 
                    onClick={() => handleStartDelivery(booking.id)}
                    className="mt-1 px-3 py-1 bg-blue-600 text-white text-xs rounded-lg hover:bg-blue-700"
                  >
                    🚚 {t('startDelivery')}
                  </button>
                </div>
              </div>
            )) : (
              <p className={`text-sm text-center ${
                darkMode ? 'text-gray-400' : 'text-gray-500'
              }`}>{t('noConfirmedBookings')}</p>
            )}
          </div>
        </div>

        {/* In-Transit Deliveries */}
        <div className={`rounded-xl p-4 border mb-4 ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`mb-3 font-semibold ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>🚚 {t('inTransitDeliveries')}</h2>
          <div className="space-y-3">
            {inTransitBookings.length > 0 ? inTransitBookings.map((booking) => (
              <div key={booking.id} className={`flex items-center justify-between p-3 rounded-lg ${
                darkMode ? 'bg-gray-700' : 'bg-gray-50'
              }`}>
                <div>
                  <p className={`text-sm mb-1 ${
                    darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{booking.client}</p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-400' : 'text-gray-500'
                  }`}>{booking.route} • {booking.weight}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm text-[#FF9500]">{booking.price}</p>
                  <button 
                    onClick={() => handleMarkAsDelivered(booking.id)}
                    className="mt-1 px-3 py-1 bg-green-600 text-white text-xs rounded-lg hover:bg-green-700"
                  >
                    ✓ {t('markAsDelivered')}
                  </button>
                </div>
              </div>
            )) : (
              <p className={`text-sm text-center ${
                darkMode ? 'text-gray-400' : 'text-gray-500'
              }`}>{t('noInTransitDeliveries')}</p>
            )}
          </div>
        </div>

        {/* Pending Bookings */}
        <div className={`rounded-xl p-4 border ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`mb-3 font-semibold ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('pendingBookings')}</h2>
          <div className="space-y-3">
            {pendingBookings.length > 0 ? pendingBookings.map((booking) => (
              <div key={booking.id} className={`flex items-center justify-between p-3 rounded-lg ${
                darkMode ? 'bg-gray-700' : 'bg-gray-50'
              }`}>
                <div>
                  <p className={`text-sm mb-1 ${
                    darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{booking.client}</p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-400' : 'text-gray-500'
                  }`}>{booking.route} • {booking.weight}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm text-[#FF9500]">{booking.price}</p>
                  <div className="flex space-x-1 mt-1">
                    <button 
                      onClick={() => handleAcceptBooking(booking.id)}
                      className={`px-2 py-1 rounded text-xs ${
                        darkMode 
                          ? 'bg-green-900/30 text-green-400 hover:bg-green-900/50' 
                          : 'bg-green-100 text-green-600 hover:bg-green-200'
                      }`}
                    >✓</button>
                    <button 
                      onClick={() => handleRejectBooking(booking.id)}
                      className={`px-2 py-1 rounded text-xs ${
                        darkMode 
                          ? 'bg-red-900/30 text-red-400 hover:bg-red-900/50' 
                          : 'bg-red-100 text-red-600 hover:bg-red-200'
                      }`}
                    >✗</button>
                  </div>
                </div>
              </div>
            )) : (
              <p className={`text-sm text-center py-4 ${
                darkMode ? 'text-gray-400' : 'text-gray-500'
              }`}>{t('noDataYet')}</p>
            )}
          </div>
        </div>

        {/* Recent Activities */}
        <div className={`rounded-xl p-4 border ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
        }`}>
          <h2 className={`mb-3 font-semibold ${
            darkMode ? 'text-white' : 'text-gray-900'
          }`}>{t('recentActivities')}</h2>
          <div className="space-y-3">
            {recentActivities.length > 0 ? recentActivities.map((activity) => (
              <div key={activity.id} className="flex items-start space-x-3">
                <div className={`w-2 h-2 rounded-full mt-2 ${
                  activity.type === 'new_booking' ? 'bg-yellow-500' :
                  activity.type === 'payment_received' ? 'bg-blue-500' :
                  activity.type === 'delivery_started' ? 'bg-purple-500' :
                  activity.type === 'delivery_completed' ? 'bg-green-500' :
                  'bg-gray-500'
                }`}></div>
                <div className="flex-1">
                  <p className={`text-sm ${
                    darkMode ? 'text-gray-300' : 'text-gray-900'
                  }`}>
                    {activity.type === 'new_booking' ? `📋 ${t('newBooking')}` :
                     activity.type === 'payment_received' ? `💰 ${t('paymentReceived')}` :
                     activity.type === 'delivery_started' ? `🚚 ${t('deliveryStarted')}` :
                     activity.type === 'delivery_completed' ? `✅ ${t('deliveryCompleted')}` :
                     `📦 ${t('bookingUpdate')}`}
                  </p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-400' : 'text-gray-500'
                  }`}>{activity.client} • {activity.route}</p>
                  <p className={`text-xs ${
                    darkMode ? 'text-gray-500' : 'text-gray-400'
                  }`}>{activity.time}</p>
                </div>
              </div>
            )) : (
              <p className={`text-sm text-center py-4 ${
                darkMode ? 'text-gray-400' : 'text-gray-500'
              }`}>{t('noRecentActivity')}</p>
            )}
          </div>
        </div>

        {/* Action Buttons */}
        <div className="grid grid-cols-2 gap-3">
          <button
            onClick={() => navigate('/create-trip')}
            className="flex items-center justify-center space-x-2 bg-[#FF9500] text-white py-4 rounded-xl hover:bg-[#E68600] transition-colors"
          >
            <Plus className="w-5 h-5" />
            <span>{t('postNewTrip')}</span>
          </button>
          <button
            onClick={() => navigate('/transporter-reviews')}
            className={`flex items-center justify-center space-x-2 border py-4 rounded-xl transition-colors ${
              darkMode 
                ? 'border-gray-600 text-gray-300 hover:bg-gray-800' 
                : 'border-gray-300 text-gray-700 hover:bg-gray-50'
            }`}
          >
            <Star className="w-5 h-5" />
            <span>{t('myReviews')}</span>
          </button>
        </div>
      </div>

      <BottomNav active="dashboard" />
    </div>
  );
}