import { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { ArrowLeft, Star, MapPin, Clock, Package, SlidersHorizontal, CheckCircle } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import UserAvatar from '../components/UserAvatar';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';
import apiService from '../services/api.service';

export default function SearchResults() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const [trips, setTrips] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const from = searchParams.get('from') || '';
  const to = searchParams.get('to') || '';
  const date = searchParams.get('date') || '';

  useEffect(() => {
    const fetchTrips = async () => {
      try {
        setLoading(true);
        const results = await apiService.getTrips();
        
        // Filter by search params if provided
        let filteredTrips = results;
        if (from) {
          filteredTrips = filteredTrips.filter((trip: any) => 
            (trip.origin_city?.toLowerCase() || '').includes(from.toLowerCase())
          );
        }
        if (to) {
          filteredTrips = filteredTrips.filter((trip: any) =>
            (trip.destination_city?.toLowerCase() || '').includes(to.toLowerCase())
          );
        }
        
        setTrips(filteredTrips);
      } catch (err: any) {
        setError(err.message || 'Erreur lors du chargement des trajets');
      } finally {
        setLoading(false);
      }
    };

    fetchTrips();
  }, [from, to, date]);

  // Remove static transporters data - all data should come from API
  // const transporters = [...]; // REMOVED

  return (
    <div className={`min-h-screen pb-20 ${darkMode ? 'bg-gray-900' : 'bg-gray-50'}`}>
      {/* Header */}
      <div className={`border-b p-4 sticky top-0 z-10 ${
        darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
      }`}>
        <div className="flex items-center space-x-3">
          <div className="flex-1">
            <p className={`text-sm ${
              darkMode ? 'text-gray-300' : 'text-gray-600'
            }`}>{from || 'Any'} → {to || 'Any'}</p>
            <p className={`text-xs ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`}>{date || 'Anytime'}</p>
          </div>
          <button className={`p-2 rounded-full ${
            darkMode ? 'hover:bg-gray-700 text-white' : 'hover:bg-gray-100 text-gray-900'
          }`}>
            <SlidersHorizontal className="w-6 h-6" />
          </button>
        </div>
      </div>

      {loading ? (
        <div className="p-8 text-center">
          <p className={darkMode ? 'text-gray-300' : 'text-gray-600'}>
            {t('loadingBookings')}
          </p>
        </div>
      ) : error ? (
        <div className={`p-4 m-4 border rounded-xl ${
          darkMode 
            ? 'bg-red-900/20 border-red-800 text-red-400' 
            : 'bg-red-50 border-red-200 text-red-700'
        }`}>
          {error}
        </div>
      ) : (
        <>
          {/* Results Count */}
          <div className={`p-4 border-b ${
            darkMode 
              ? 'bg-blue-900/20 border-blue-800' 
              : 'bg-blue-50 border-blue-100'
          }`}>
            <p className={`text-sm ${
              darkMode ? 'text-gray-300' : 'text-gray-700'
            }`}>
              <span>{trips.length} {trips.length > 1 ? t('resultsFound') : t('result')}</span>
            </p>
          </div>

          {/* Transport Offers */}
          <div className="p-4 space-y-3">
            {trips.length === 0 ? (
              <div className="text-center py-12">
                <Package className={`w-16 h-16 mx-auto mb-4 ${
                  darkMode ? 'text-gray-600' : 'text-gray-300'
                }`} />
                <p className={`mb-2 ${
                  darkMode ? 'text-gray-300' : 'text-gray-600'
                }`}>{t('noTripsAvailable')}</p>
                <p className={`text-sm ${
                  darkMode ? 'text-gray-500' : 'text-gray-400'
                }`}>{t('tryModifying')}</p>
              </div>
            ) : (
              trips.map((trip) => (
                <div
                  key={trip.id}
                  onClick={() => navigate(`/transport/${trip.id}`)}
                  className={`rounded-xl p-4 shadow-sm border cursor-pointer transition-shadow ${
                    darkMode 
                      ? 'bg-gray-800 border-gray-700 hover:shadow-lg' 
                      : 'bg-white border-gray-100 hover:shadow-md'
                  }`}
                >
                  {/* Transporter Info */}
                  <div className="flex items-start justify-between mb-3">
                    <div className="flex items-center space-x-3">
                      <UserAvatar 
                        user={trip.transporter ? {
                          id: trip.transporter.id?.toString() || '',
                          name: trip.transporter.name || 'Transporter',
                          email: '',
                          phone: '',
                          type: 'transporter'
                        } : null} 
                        size="md" 
                      />
                      <div>
                        <div className="flex items-center space-x-1">
                          <p className={darkMode ? 'text-white' : 'text-gray-900'}>
                            {trip.transporter?.name || 'Transporter'}
                          </p>
                          {trip.transporter?.is_verified && (
                            <CheckCircle className="w-4 h-4 text-blue-500 fill-current" />
                          )}
                        </div>
                        <div className={`flex items-center space-x-1 text-xs ${
                          darkMode ? 'text-gray-400' : 'text-gray-500'
                        }`}>
                          <Star className="w-3 h-3 text-yellow-400 fill-current" />
                          <span>{trip.transporter?.rating?.toFixed(1) || '0.0'}</span>
                        </div>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="text-lg text-[#0066FF]">{trip.price_per_kg}€</p>
                      <p className={`text-xs ${
                        darkMode ? 'text-gray-400' : 'text-gray-500'
                      }`}>{t('perKg')}</p>
                    </div>
                  </div>

                  {/* Route Info */}
                  <div className={`flex items-center space-x-2 text-sm mb-2 ${
                    darkMode ? 'text-gray-400' : 'text-gray-600'
                  }`}>
                    <MapPin className="w-4 h-4" />
                    <span>{trip.origin_city || 'N/A'} → {trip.destination_city || 'N/A'}</span>
                  </div>

                  <div className={`flex items-center space-x-2 text-sm mb-3 ${
                    darkMode ? 'text-gray-400' : 'text-gray-600'
                  }`}>
                    <Clock className="w-4 h-4" />
                    <span>{new Date(trip.departure_date).toLocaleDateString('fr-FR', { 
                      day: 'numeric', 
                      month: 'short',
                      hour: '2-digit',
                      minute: '2-digit'
                    })}</span>
                  </div>

                  <div className={`flex items-center space-x-2 text-sm mb-3 ${
                    darkMode ? 'text-gray-400' : 'text-gray-600'
                  }`}>
                    <Package className="w-4 h-4" />
                    <span>{trip.available_weight}kg {t('available')}</span>
                  </div>

                  <button className="w-full bg-[#0066FF] text-white py-2.5 rounded-lg text-sm">
                    {t('viewDetails')}
                  </button>
                </div>
              ))
            )}
          </div>
        </>
      )}

      <BottomNav active="search" />
    </div>
  );
}
