import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Edit, Trash2, MapPin, Calendar, Weight, DollarSign, Package, AlertCircle, X, Plus } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import apiService from '../services/api.service';
import { useLanguage } from '../contexts/LanguageContext';

interface Trip {
  id: number;
  origin_city: string;
  destination_city: string;
  departure_date: string;
  max_weight: number;
  available_weight: number;
  price_per_kg: number;
  vehicle_type?: string;
  vehicle_number?: string;
  notes?: string;
  is_active: boolean;
}

interface Booking {
  id: number;
  trip_id: number;
  status: string;
  is_paid: boolean;
  weight: number;
  total_price: number;
}

export default function MyTrips() {
  const navigate = useNavigate();
  const { t } = useLanguage();
  const [trips, setTrips] = useState<Trip[]>([]);
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'active' | 'passed'>('active');
  const [editingTrip, setEditingTrip] = useState<Trip | null>(null);
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const [tripToDelete, setTripToDelete] = useState<Trip | null>(null);
  const [deleteError, setDeleteError] = useState<string>('');

  useEffect(() => {
    fetchTripsAndBookings();
  }, []);

  const fetchTripsAndBookings = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        navigate('/login');
        return;
      }

      const [tripsData, bookingsData] = await Promise.all([
        apiService.getMyTrips(token),
        apiService.getMyBookings(token)
      ]);

      setTrips(tripsData);
      setBookings(bookingsData);
    } catch (err: any) {
      console.error('Error fetching trips:', err);
    } finally {
      setLoading(false);
    }
  };

  const filteredTrips = trips.filter(trip => {
    const tripDate = new Date(trip.departure_date);
    const now = new Date();
    
    if (activeTab === 'active') {
      return tripDate >= now && trip.is_active;
    } else {
      return tripDate < now || !trip.is_active;
    }
  });

  const handleEdit = (trip: Trip) => {
    setEditingTrip(trip);
  };

  const handleDelete = (trip: Trip) => {
    // Vérifier s'il y a des bookings payés pour ce trajet
    const paidBookings = bookings.filter(
      b => b.trip_id === trip.id && b.is_paid
    );

    if (paidBookings.length > 0) {
      setDeleteError(`Impossible de supprimer ce trajet. ${paidBookings.length} réservation(s) payée(s) existe(nt).`);
      setTripToDelete(trip);
      setShowDeleteDialog(true);
    } else {
      setDeleteError('');
      setTripToDelete(trip);
      setShowDeleteDialog(true);
    }
  };

  const confirmDelete = async () => {
    if (!tripToDelete || deleteError) return;

    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      await apiService.deleteTrip(tripToDelete.id, token);
      
      // Rafraîchir la liste
      await fetchTripsAndBookings();
      
      setShowDeleteDialog(false);
      setTripToDelete(null);
      alert('✅ Trajet supprimé avec succès');
    } catch (err: any) {
      alert('❌ Erreur: ' + err.message);
    }
  };

  const handleUpdateTrip = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingTrip) return;

    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      // Préparer les données pour le backend
      const updateData = {
        departure_date: editingTrip.departure_date,
        max_weight: editingTrip.max_weight,
        price_per_kg: editingTrip.price_per_kg,
        notes: editingTrip.notes || null
      };

      await apiService.updateTrip(editingTrip.id, updateData, token);
      
      // Rafraîchir la liste
      await fetchTripsAndBookings();
      
      setEditingTrip(null);
      alert('✅ Trajet mis à jour avec succès\n\n📢 Les clients verront automatiquement les changements!');
    } catch (err: any) {
      alert('❌ Erreur: ' + err.message);
    }
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
          <button onClick={() => navigate('/transporter-dashboard')} className="p-2 hover:bg-gray-100 rounded-full">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-bold ml-3">{t('myTrips')}</h1>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white border-b border-gray-200 px-4 py-2">
        <div className="flex space-x-2">
          <button
            onClick={() => setActiveTab('active')}
            className={`flex-1 py-2 px-4 rounded-lg font-medium transition-colors ${
              activeTab === 'active'
                ? 'bg-[#FF6B00] text-white'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {t('activeTrips')} ({trips.filter(t => new Date(t.departure_date) >= new Date() && t.is_active).length})
          </button>
          <button
            onClick={() => setActiveTab('passed')}
            className={`flex-1 py-2 px-4 rounded-lg font-medium transition-colors ${
              activeTab === 'passed'
                ? 'bg-[#FF6B00] text-white'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {t('pastTrips')} ({trips.filter(t => new Date(t.departure_date) < new Date() || !t.is_active).length})
          </button>
        </div>
      </div>

      {/* Trips List */}
      <div className="p-4 space-y-4">
        {filteredTrips.length === 0 ? (
          <div className="bg-white rounded-xl p-8 text-center">
            <Package className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <p className="text-gray-500 mb-4">
              {activeTab === 'active' ? t('noActiveTrips') : t('noPastTrips')}
            </p>
            <button
              onClick={() => navigate('/create-trip')}
              className="bg-[#FF6B00] text-white px-6 py-2 rounded-lg font-semibold hover:bg-[#e55f00] transition-colors"
            >
              {t('createFirstTrip')}
            </button>
          </div>
        ) : (
          filteredTrips.map(trip => {
            const tripBookings = bookings.filter(b => b.trip_id === trip.id);
            const paidBookings = tripBookings.filter(b => b.is_paid);
            
            return (
              <div key={trip.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
                <div className="flex justify-between items-start mb-3">
                  <div className="flex-1">
                    <div className="flex items-center space-x-2 mb-2">
                      <MapPin className="w-5 h-5 text-[#0066FF]" />
                      <span className="font-semibold text-lg">
                        {trip.origin_city} → {trip.destination_city}
                      </span>
                    </div>
                    <div className="flex items-center space-x-2 text-sm text-gray-600 mb-1">
                      <Calendar className="w-4 h-4" />
                      <span>{new Date(trip.departure_date).toLocaleDateString('fr-FR')}</span>
                    </div>
                    <div className="flex items-center space-x-4 text-sm text-gray-600">
                      <div className="flex items-center space-x-1">
                        <Weight className="w-4 h-4" />
                        <span>{trip.available_weight}/{trip.max_weight}kg</span>
                      </div>
                      <div className="flex items-center space-x-1">
                        <DollarSign className="w-4 h-4" />
                        <span>{trip.price_per_kg}€/kg</span>
                      </div>
                    </div>
                  </div>
                  
                  {activeTab === 'active' && (
                    <div className="flex space-x-2">
                      <button
                        onClick={() => handleEdit(trip)}
                        className="p-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors"
                        title="Modifier"
                      >
                        <Edit className="w-5 h-5" />
                      </button>
                      <button
                        onClick={() => handleDelete(trip)}
                        className="p-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 transition-colors"
                        title="Supprimer"
                      >
                        <Trash2 className="w-5 h-5" />
                      </button>
                    </div>
                  )}
                </div>

                {/* Booking stats */}
                <div className="mt-3 pt-3 border-t border-gray-100 flex items-center justify-between text-sm">
                  <span className="text-gray-600">
                    📦 {tripBookings.length} {t('bookings')}
                  </span>
                  {paidBookings.length > 0 && (
                    <span className="text-green-600 font-medium">
                      ✅ {paidBookings.length} {t('paid')}
                    </span>
                  )}
                </div>
              </div>
            );
          })
        )}
      </div>

      {/* FAB */}
      <button
        onClick={() => navigate('/create-trip')}
        className="fixed bottom-20 right-6 w-14 h-14 bg-[#FF6B00] text-white rounded-full shadow-lg flex items-center justify-center hover:bg-[#e55f00] transition-colors z-10"
      >
        <Plus className="w-6 h-6" />
      </button>

      {/* Edit Modal */}
      {/* FAB */}
      <button
        onClick={() => navigate('/create-trip')}
        className="fixed bottom-20 right-6 w-14 h-14 bg-[#FF6B00] text-white rounded-full shadow-lg flex items-center justify-center hover:bg-[#e55f00] transition-colors z-10"
      >
        <Plus className="w-6 h-6" />
      </button>

      {/* Edit Modal */}
      {editingTrip && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl w-full max-w-md max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-200 p-4 flex justify-between items-center">
              <h2 className="text-xl font-bold">{t('editTrip')}</h2>
              <button
                onClick={() => setEditingTrip(null)}
                className="p-2 hover:bg-gray-100 rounded-full"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleUpdateTrip} className="p-4 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  {t('departureDate')}
                </label>
                <input
                  type="datetime-local"
                  value={new Date(editingTrip.departure_date).toISOString().slice(0, 16)}
                  onChange={(e) => setEditingTrip({
                    ...editingTrip,
                    departure_date: new Date(e.target.value).toISOString()
                  })}
                  className="w-full p-3 border border-gray-300 rounded-lg"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  {t('maxWeight')}
                </label>
                <input
                  type="number"
                  step="0.1"
                  value={editingTrip.max_weight}
                  onChange={(e) => setEditingTrip({
                    ...editingTrip,
                    max_weight: parseFloat(e.target.value)
                  })}
                  className="w-full p-3 border border-gray-300 rounded-lg"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  {t('pricePerKg')}
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={editingTrip.price_per_kg}
                  onChange={(e) => setEditingTrip({
                    ...editingTrip,
                    price_per_kg: parseFloat(e.target.value)
                  })}
                  className="w-full p-3 border border-gray-300 rounded-lg"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  {t('notes')}
                </label>
                <textarea
                  value={editingTrip.notes || ''}
                  onChange={(e) => setEditingTrip({
                    ...editingTrip,
                    notes: e.target.value
                  })}
                  className="w-full p-3 border border-gray-300 rounded-lg"
                  rows={3}
                />
              </div>

              <div className="flex space-x-3">
                <button
                  type="button"
                  onClick={() => setEditingTrip(null)}
                  className="flex-1 py-3 px-4 border border-gray-300 text-gray-700 rounded-lg font-semibold hover:bg-gray-50 transition-colors"
                >
                  {t('cancel')}
                </button>
                <button
                  type="submit"
                  className="flex-1 py-3 px-4 bg-[#0066FF] text-white rounded-lg font-semibold hover:bg-[#0052CC] transition-colors"
                >
                  {t('save')}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Delete Dialog */}
      {showDeleteDialog && tripToDelete && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl w-full max-w-md p-6">
            <div className="flex items-start space-x-3 mb-4">
              <AlertCircle className={`w-6 h-6 ${deleteError ? 'text-red-500' : 'text-yellow-500'}`} />
              <div className="flex-1">
                <h3 className="text-lg font-bold mb-2">
                  {deleteError ? t('cannotDelete') : t('confirmDelete')}
                </h3>
                {deleteError ? (
                  <p className="text-red-600">{deleteError}</p>
                ) : (
                  <p className="text-gray-600">
                    {t('deleteConfirmMessage')} <strong>{tripToDelete.origin_city} → {tripToDelete.destination_city}</strong> ?
                    <br /><br />
                    {t('unpaidBookingsWillBeDeleted')}
                  </p>
                )}
              </div>
            </div>

            <div className="flex space-x-3">
              <button
                onClick={() => {
                  setShowDeleteDialog(false);
                  setTripToDelete(null);
                  setDeleteError('');
                }}
                className="flex-1 py-3 px-4 border border-gray-300 text-gray-700 rounded-lg font-semibold hover:bg-gray-50 transition-colors"
              >
                {deleteError ? t('close') : t('cancel')}
              </button>
              {!deleteError && (
                <button
                  onClick={confirmDelete}
                  className="flex-1 py-3 px-4 bg-red-600 text-white rounded-lg font-semibold hover:bg-red-700 transition-colors"
                >
                  {t('delete')}
                </button>
              )}
            </div>
          </div>
        </div>
      )}

      <BottomNav active="trips" />
    </div>
  );
}
