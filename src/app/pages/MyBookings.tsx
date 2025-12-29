import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, MapPin, Calendar, Package, Star } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';
import { useTheme } from '../contexts/ThemeContext';
import apiService from '../services/api.service';

interface Booking {
  id: number;
  trip_id: number;
  weight: number;
  total_price: number;
  status: string;
  is_paid: boolean;
  tracking_number: string;
  pickup_address: string;
  delivery_address: string;
  created_at: string;
  trip: {
    origin_city: string;
    destination_city: string;
    departure_date: string;
    transporter_id: number;
    transporter: {
      name: string;
    };
  };
}

export default function MyBookings() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { t } = useLanguage();
  const { darkMode } = useTheme();
  const [activeTab, setActiveTab] = useState<'active' | 'completed'>('active');
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchBookings();
  }, []);

  const fetchBookings = async () => {
    try {
      setLoading(true);
      setError('');
      const token = localStorage.getItem('token');
      if (!token) {
        setError('Please login to view your bookings');
        setLoading(false);
        return;
      }

      const data = await apiService.getMyBookings(token);
      
      // Vérifier que data est un tableau
      if (Array.isArray(data)) {
        console.log('Bookings received:', data);
        // S'assurer que is_paid est toujours défini
        const bookingsWithPaidStatus = data.map(booking => ({
          ...booking,
          is_paid: booking.is_paid === true
        }));
        setBookings(bookingsWithPaidStatus);
      } else {
        console.warn('Bookings data is not an array:', data);
        setBookings([]);
      }
    } catch (err: any) {
      setError(err.message || 'Failed to load bookings');
      console.error('Error fetching bookings:', err);
      setBookings([]); // S'assurer que bookings est toujours un tableau
    } finally {
      setLoading(false);
    }
  };

  // Filter bookings by active/completed
  const filteredBookings = bookings.filter(booking => {
    // Vérifier que booking et booking.status existent
    if (!booking || !booking.status) return false;
    
    if (activeTab === 'active') {
      return ['pending', 'confirmed', 'in_transit'].includes(booking.status.toLowerCase());
    } else {
      return ['delivered', 'cancelled'].includes(booking.status.toLowerCase());
    }
  });

  const getStatusColor = (status: string) => {
    const statusLower = status.toLowerCase();
    if (statusLower === 'confirmed') return 'bg-blue-100 text-blue-700';
    if (statusLower === 'pending') return 'bg-yellow-100 text-yellow-700';
    if (statusLower === 'delivered') return 'bg-green-100 text-green-700';
    if (statusLower === 'in_transit') return 'bg-purple-100 text-purple-700';
    if (statusLower === 'cancelled') return 'bg-red-100 text-red-700';
    return 'bg-gray-100 text-gray-700';
  };



  return (
    <div className={`min-h-screen pb-20 ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      <div className={`border-b p-4 sticky top-0 z-10 ${
        darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
      }`}>
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate('/home')} className={`p-2 rounded-full ${
            darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
          }`}>
            <ArrowLeft className={`w-6 h-6 ${
              darkMode ? 'text-white' : ''
            }`} />
          </button>
          <h1 className={`text-xl ${
            darkMode ? 'text-white' : ''
          }`}>{t('myBookings')}</h1>
        </div>
      </div>

      {/* Tabs */}
      <div className={`border-b p-4 ${
        darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
      }`}>
        <div className="flex gap-2">
          <button
            onClick={() => setActiveTab('active')}
            className={`flex-1 py-3 rounded-xl transition-colors ${
              activeTab === 'active' ? 'bg-[#0066FF] text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'
            }`}
          >
            {t('active')} ({filteredBookings.filter(b => ['pending', 'confirmed', 'in_transit'].includes(b.status.toLowerCase())).length})
          </button>
          <button
            onClick={() => setActiveTab('completed')}
            className={`flex-1 py-3 rounded-xl transition-colors ${
              activeTab === 'completed' ? 'bg-[#0066FF] text-white' : darkMode ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'
            }`}
          >
            {t('completed')} ({filteredBookings.filter(b => ['delivered', 'cancelled'].includes(b.status.toLowerCase())).length})
          </button>
        </div>
      </div>

      {loading && (
        <div className="p-8 text-center">
          <div className={`inline-block animate-spin rounded-full h-8 w-8 border-4 border-t-[#0066FF] ${
            darkMode ? 'border-gray-700' : 'border-gray-200'
          }`}></div>
          <p className={`mt-2 ${
            darkMode ? 'text-gray-400' : 'text-gray-600'
          }`}>{t('loadingBookings')}</p>
        </div>
      )}

      {error && (
        <div className={`p-4 m-4 border rounded-xl ${
          darkMode ? 'bg-red-900/20 border-red-800' : 'bg-red-50 border-red-200'
        }`}>
          <p className={`text-sm ${
            darkMode ? 'text-red-400' : 'text-red-600'
          }`}>{error}</p>
        </div>
      )}

      {!loading && !error && filteredBookings.length === 0 && (
        <div className="p-8 text-center">
          <Package className={`w-16 h-16 mx-auto mb-4 ${
            darkMode ? 'text-gray-600' : 'text-gray-300'
          }`} />
          <p className={darkMode ? 'text-gray-400' : 'text-gray-600'}>{activeTab === 'active' ? t('noActiveBookings') : t('noCompletedBookings')}</p>
          <button
            onClick={() => navigate('/search')}
            className="mt-4 px-6 py-2 bg-[#0066FF] text-white rounded-xl"
          >
            {t('findTrips')}
          </button>
        </div>
      )}

      <div className="p-4 space-y-3">
        {!loading && !error && filteredBookings.map((booking) => {
          // Vérifications de sécurité
          if (!booking || !booking.trip) return null;
          
          const formattedDate = booking.trip.departure_date 
            ? new Date(booking.trip.departure_date).toLocaleDateString('en-US', { 
                month: 'short', 
                day: 'numeric' 
              })
            : t('notAvailable');

          return (
            <div
              key={booking.id}
              className={`rounded-xl p-4 shadow-sm border ${
                darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-100'
              }`}
            >
              <div className="flex items-start justify-between mb-3">
                <div>
                  <div className="flex items-center space-x-2 mb-2">
                    <MapPin className={`w-4 h-4 ${
                      darkMode ? 'text-gray-500' : 'text-gray-400'
                    }`} />
                    <span className={`text-sm ${
                      darkMode ? 'text-gray-300' : ''
                    }`}>
                      {booking.trip?.origin_city || t('unknown')} → {booking.trip?.destination_city || t('unknown')}
                    </span>
                  </div>
                  <div className="flex items-center space-x-2 mb-1">
                    <Calendar className={`w-4 h-4 ${
                      darkMode ? 'text-gray-500' : 'text-gray-400'
                    }`} />
                    <span className={`text-sm ${
                      darkMode ? 'text-gray-400' : 'text-gray-600'
                    }`}>{formattedDate}</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Package className={`w-4 h-4 ${
                      darkMode ? 'text-gray-500' : 'text-gray-400'
                    }`} />
                    <span className={`text-sm ${
                      darkMode ? 'text-gray-400' : 'text-gray-600'
                    }`}>{booking.weight || 0}kg</span>
                  </div>
                </div>
                <div className="text-right">
                  <span className={`inline-block px-3 py-1 rounded-full text-xs ${getStatusColor(booking.status)}`}>
                    {t(booking.status.toLowerCase())}
                  </span>
                  <p className="text-lg text-[#0066FF] mt-2">{(booking.total_price || 0).toFixed(2)}€</p>
                </div>
              </div>
              <div className={`text-xs mt-2 border-t pt-2 ${
                darkMode ? 'text-gray-500 border-gray-700' : 'text-gray-500 border-gray-100'
              }`}>
                <p>{t('tracking')}: {booking.tracking_number || t('notAvailable')}</p>
                <p className="mt-1">{t('transporter')}: {booking.trip?.transporter?.name || t('unknown')}</p>
                {/* Debug info */}
                <p className={`mt-1 ${
                  darkMode ? 'text-red-400' : 'text-red-500'
                }`}>{t('status')}: {t(booking.status.toLowerCase())}, {t('paid')}: {booking.is_paid ? t('yes') : t('no')}</p>
              </div>
              
              {/* Confirmed message and payment button */}
              {booking.status.toLowerCase() === 'confirmed' && booking.is_paid !== true && (
                <>
                  <div className={`mt-3 p-2 border rounded-lg ${
                    darkMode ? 'bg-green-900/20 border-green-800' : 'bg-green-50 border-green-200'
                  }`}>
                    <p className={`text-xs font-medium ${
                      darkMode ? 'text-green-400' : 'text-green-700'
                    }`}>✅ {t('acceptedByTransporter')}</p>
                    <p className={`text-xs mt-1 ${
                      darkMode ? 'text-green-500' : 'text-green-600'
                    }`}>💳 {t('canProceedPayment')}</p>
                  </div>
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      navigate('/payment', {
                        state: {
                          bookingId: booking.id,
                          totalPrice: booking.total_price,
                          trackingNumber: booking.tracking_number,
                          tripDetails: {
                            origin: booking.trip?.origin_city || '',
                            destination: booking.trip?.destination_city || ''
                          }
                        }
                      });
                    }}
                    className="w-full mt-2 bg-[#0066FF] text-white py-2 rounded-lg font-semibold hover:bg-[#0052CC] transition-colors"
                  >
                    {t('payNow')} - {(booking.total_price || 0).toFixed(2)}€
                  </button>
                </>
              )}
              
              {/* In Transit message */}
              {booking.status.toLowerCase() === 'in_transit' && (
                <div className={`mt-3 p-2 border rounded-lg ${
                  darkMode ? 'bg-purple-900/20 border-purple-800' : 'bg-purple-50 border-purple-200'
                }`}>
                  <p className={`text-xs font-medium ${
                    darkMode ? 'text-purple-400' : 'text-purple-700'
                  }`}>🚚 {t('packageInTransit')}</p>
                  <p className={`text-xs mt-1 ${
                    darkMode ? 'text-purple-500' : 'text-purple-600'
                  }`}>📦 {t('packageOnTheWay')}</p>
                </div>
              )}
              
              {/* Pending message */}
              {booking.status.toLowerCase() === 'pending' && (
                <div className={`mt-3 p-2 border rounded-lg ${
                  darkMode ? 'bg-yellow-900/20 border-yellow-800' : 'bg-yellow-50 border-yellow-200'
                }`}>
                  <p className={`text-xs font-medium ${
                    darkMode ? 'text-yellow-400' : 'text-yellow-700'
                  }`}>⏳ {t('pendingApproval')}</p>
                  <p className={`text-xs mt-1 ${
                    darkMode ? 'text-yellow-500' : 'text-yellow-600'
                  }`}>💡 {t('payAfterAcceptance')}</p>
                </div>
              )}
              
              {/* Cancelled message */}
              {booking.status.toLowerCase() === 'cancelled' && (
                <>
                  <div className={`mt-3 p-2 border rounded-lg ${
                    darkMode ? 'bg-red-900/20 border-red-800' : 'bg-red-50 border-red-200'
                  }`}>
                    <p className={`text-xs font-medium ${
                      darkMode ? 'text-red-400' : 'text-red-700'
                    }`}>❌ {t('bookingRejected')}</p>
                    <p className={`text-xs mt-1 ${
                      darkMode ? 'text-red-500' : 'text-red-600'
                    }`}>💰 {t('noPaymentMade')}</p>
                  </div>
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      navigate('/search', {
                        state: {
                          origin: booking.origin_city,
                          destination: booking.destination_city
                        }
                      });
                    }}
                    className={`w-full mt-2 text-white py-2 rounded-lg font-semibold transition-colors ${
                      darkMode ? 'bg-gray-700 hover:bg-gray-600' : 'bg-gray-600 hover:bg-gray-700'
                    }`}
                  >
                    🔍 {t('searchAnotherTrip')}
                  </button>
                </>
              )}
              
              {/* Delivered message with review button */}
              {booking.status.toLowerCase() === 'delivered' && (
                <div className="mt-3 space-y-2">
                  <div className={`p-2 border rounded-lg ${
                    darkMode ? 'bg-green-900/20 border-green-800' : 'bg-green-50 border-green-200'
                  }`}>
                    <p className={`text-xs font-medium ${
                      darkMode ? 'text-green-400' : 'text-green-700'
                    }`}>✅ {t('deliveredSuccessfully')}</p>
                    <p className={`text-xs mt-1 ${
                      darkMode ? 'text-green-500' : 'text-green-600'
                    }`}>📦 {t('packageDelivered')}</p>
                  </div>
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      navigate('/leave-review', {
                        state: {
                          bookingId: booking.id,
                          transporterId: booking.trip?.transporter_id,
                          transporterName: booking.trip?.transporter?.name || t('unknown'),
                          tripDetails: {
                            origin: booking.trip?.origin_city || '',
                            destination: booking.trip?.destination_city || ''
                          }
                        }
                      });
                    }}
                    className="w-full bg-amber-500 text-white py-2 rounded-lg font-semibold hover:bg-amber-600 transition-colors flex items-center justify-center space-x-2"
                  >
                    <Star className="w-5 h-5" />
                    <span>{t('leaveReview')}</span>
                  </button>
                </div>
              )}
            </div>
          );
        })}
      </div>

      <BottomNav active="bookings" />
    </div>
  );
}
