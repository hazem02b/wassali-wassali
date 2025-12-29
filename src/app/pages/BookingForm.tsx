import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Upload, MapPin } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { useAuth } from '../contexts/AuthContext';
import apiService from '../services/api.service';

export default function BookingForm() {
  const navigate = useNavigate();
  const { id } = useParams();
  const { user } = useAuth();
  const [savePickup, setSavePickup] = useState(false);
  const [saveDelivery, setSaveDelivery] = useState(false);
  const [trip, setTrip] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  
  // Form fields
  const [description, setDescription] = useState('');
  const [weight, setWeight] = useState('');
  const [itemType, setItemType] = useState('');
  const [pickupAddress, setPickupAddress] = useState('');
  const [pickupCity, setPickupCity] = useState('');
  const [deliveryAddress, setDeliveryAddress] = useState('');
  const [deliveryCity, setDeliveryCity] = useState('');
  const [recipientName, setRecipientName] = useState('');
  const [recipientPhone, setRecipientPhone] = useState('');
  const [notes, setNotes] = useState('');
  const [packagePhoto, setPackagePhoto] = useState<string>('');
  const [photoFile, setPhotoFile] = useState<File | null>(null);

  useEffect(() => {
    const fetchTrip = async () => {
      try {
        const trips = await apiService.getTrips();
        const foundTrip = trips.find((t: any) => t.id === parseInt(id || '0'));
        if (foundTrip) {
          setTrip(foundTrip);
        } else {
          setError('Trajet non trouvé');
        }
      } catch (err: any) {
        setError(err.message || 'Erreur lors du chargement');
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchTrip();
    }
  }, [id]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    try {
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error('Vous devez être connecté');
      }

      const bookingData = {
        trip_id: parseInt(id || '0'),
        weight: parseFloat(weight),
        item_type: itemType,
        description: description,
        pickup_address: pickupAddress,
        pickup_city: pickupCity,
        delivery_address: deliveryAddress,
        delivery_city: deliveryCity,
        recipient_name: recipientName,
        recipient_phone: recipientPhone,
        notes: notes || undefined,
      };

      const result = await apiService.createBooking(bookingData, token);
      
      // Ne pas rediriger vers le paiement immédiatement
      // Le transporteur doit d'abord accepter la réservation
      alert('✅ Réservation envoyée avec succès!\n\n💡 Important: Vous ne paierez QU\'APRÈS que le transporteur accepte votre demande.\n\n🔒 Votre argent est protégé - aucun paiement avant confirmation!');
      
      // Rediriger vers My Bookings pour voir le statut
      navigate('/my-bookings');
    } catch (err: any) {
      setError(err.message || 'Erreur lors de la réservation');
    }
  };

  const calculateTotal = () => {
    if (!trip || !weight) return { transportFee: 0, serviceFee: 0, total: 0 };
    const transportFee = trip.price_per_kg * parseFloat(weight);
    const serviceFee = transportFee * 0.1; // 10% frais de service
    return {
      transportFee,
      serviceFee,
      total: transportFee + serviceFee
    };
  };

  const handlePhotoUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      // Vérifier la taille du fichier (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        setError('Image size must be less than 5MB');
        return;
      }

      // Vérifier le type de fichier
      if (!file.type.startsWith('image/')) {
        setError('Please upload an image file');
        return;
      }

      setPhotoFile(file);
      
      // Créer une preview
      const reader = new FileReader();
      reader.onloadend = () => {
        setPackagePhoto(reader.result as string);
      };
      reader.readAsDataURL(file);
      setError('');
    }
  };

  const removePhoto = () => {
    setPackagePhoto('');
    setPhotoFile(null);
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-32">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <button
          onClick={() => navigate(`/transport/${id}`)}
          className="p-2 hover:bg-gray-100 rounded-full inline-flex"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
      </div>

      {loading ? (
        <div className="p-8 text-center">
          <p className="text-gray-600">Chargement...</p>
        </div>
      ) : error ? (
        <div className="p-4 m-4 bg-red-50 border border-red-200 text-red-700 rounded-xl">
          {error}
        </div>
      ) : trip ? (
        <>
          {/* Transport Summary */}
          <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6 mb-4">
            <h2 className="text-lg mb-2">Trip Summary</h2>
            <p className="text-blue-100">{trip.origin_city} → {trip.destination_city}</p>
            <p className="text-sm text-blue-100">
              {new Date(trip.departure_date).toLocaleDateString('fr-FR', {
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
              })}
            </p>
          </div>

      <form onSubmit={handleSubmit} className="px-6 space-y-6">
        {/* Package Details */}
        <div>
          <h2 className="text-lg mb-4">Package Details</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Item Type</label>
              <select
                value={itemType}
                onChange={(e) => setItemType(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                required
              >
                <option value="">Select item type</option>
                <option value="Documents">Documents</option>
                <option value="Clothing">Clothing</option>
                <option value="Electronics">Electronics</option>
                <option value="Food">Food</option>
                <option value="Other">Other</option>
              </select>
            </div>

            <div>
              <label className="block text-sm mb-2">Item Description</label>
              <textarea
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                rows={3}
                placeholder="Describe your package..."
              />
            </div>

            <div>
              <label className="block text-sm mb-2 font-semibold">Weight (kg) *</label>
              <input
                type="number"
                step="0.1"
                value={weight}
                onChange={(e) => setWeight(e.target.value)}
                max={trip?.available_weight}
                className="w-full px-4 py-3 bg-white rounded-xl border-2 border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF] focus:border-[#0066FF] text-lg font-semibold"
                placeholder="0.0"
                required
              />
              <div className="flex justify-between items-center mt-2">
                <p className="text-xs text-gray-500">
                  Max: {trip?.available_weight} kg available
                </p>
                {weight && parseFloat(weight) > 0 && trip && trip.price_per_kg && (
                  <p className="text-sm font-semibold text-[#0066FF]">
                    = {(trip.price_per_kg * parseFloat(weight)).toFixed(2)}€
                  </p>
                )}
              </div>
            </div>

            <div>
              <label className="block text-sm mb-2">Package Photo (Optional)</label>
              {!packagePhoto ? (
                <label className="w-full px-4 py-8 bg-white rounded-xl border-2 border-dashed border-gray-200 flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 transition-colors">
                  <input
                    type="file"
                    accept="image/*"
                    onChange={handlePhotoUpload}
                    className="hidden"
                  />
                  <Upload className="w-8 h-8 text-gray-400 mb-2" />
                  <p className="text-sm text-gray-600">Upload package photo</p>
                  <p className="text-xs text-gray-400 mt-1">Max 5MB (JPG, PNG)</p>
                </label>
              ) : (
                <div className="relative w-full bg-white rounded-xl border border-gray-200 overflow-hidden">
                  <img 
                    src={packagePhoto} 
                    alt="Package preview" 
                    className="w-full h-48 object-cover"
                  />
                  <button
                    type="button"
                    onClick={removePhoto}
                    className="absolute top-2 right-2 bg-red-500 text-white rounded-full p-2 hover:bg-red-600 transition-colors"
                  >
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              )}
            </div>

            <div>
              <label className="block text-sm mb-2">Special Notes (Optional)</label>
              <textarea
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                rows={2}
                placeholder="Any special instructions..."
              />
            </div>
          </div>
        </div>

        {/* Addresses */}
        <div>
          <h2 className="text-lg mb-4">Pickup Information</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Pickup Address</label>
              <div className="relative">
                <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  value={pickupAddress}
                  onChange={(e) => setPickupAddress(e.target.value)}
                  className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                  placeholder="Enter pickup address"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-sm mb-2">Pickup City</label>
              <input
                type="text"
                value={pickupCity}
                onChange={(e) => setPickupCity(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="Enter pickup city"
                required
              />
            </div>
          </div>
        </div>

        {/* Delivery Information */}
        <div>
          <h2 className="text-lg mb-4">Delivery Information</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Recipient Name</label>
              <input
                type="text"
                value={recipientName}
                onChange={(e) => setRecipientName(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="Full name of recipient"
                required
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Recipient Phone</label>
              <input
                type="tel"
                value={recipientPhone}
                onChange={(e) => setRecipientPhone(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="+33 6 12 34 56 78"
                required
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Delivery Address</label>
              <div className="relative">
                <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  value={deliveryAddress}
                  onChange={(e) => setDeliveryAddress(e.target.value)}
                  className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                  placeholder="Enter delivery address"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-sm mb-2">Delivery City</label>
              <input
                type="text"
                value={deliveryCity}
                onChange={(e) => setDeliveryCity(e.target.value)}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="Enter delivery city"
                required
              />
            </div>
          </div>
        </div>

        {/* Reservation Summary */}
        <div className="bg-gradient-to-br from-blue-50 to-white rounded-xl p-5 border-2 border-[#0066FF] shadow-sm">
          <h3 className="text-lg font-semibold mb-4 text-gray-900">Reservation Summary</h3>
          {trip && (
            <div className="space-y-3 text-sm">
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Price per kg</span>
                <span className="font-semibold text-gray-900">{trip.price_per_kg}€/kg</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Weight</span>
                <span className="font-semibold text-gray-900">{weight || 0} kg</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Subtotal</span>
                <span className="font-semibold text-gray-900">{calculateTotal().transportFee.toFixed(2)}€</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Service fee (10%)</span>
                <span className="font-semibold text-gray-900">{calculateTotal().serviceFee.toFixed(2)}€</span>
              </div>
              <div className="border-t-2 border-gray-200 pt-3 mt-3"></div>
              <div className="flex justify-between items-center">
                <span className="text-lg font-bold text-gray-900">Total</span>
                <span className="text-2xl font-bold text-[#0066FF]">{calculateTotal().total.toFixed(2)}€</span>
              </div>
              {weight && parseFloat(weight) > 0 && trip && trip.price_per_kg && (
                <div className="mt-3 p-3 bg-green-50 rounded-lg border border-green-200">
                  <p className="text-xs text-green-700">
                    ✓ Cost calculated: {weight} kg × {trip.price_per_kg}€ = {calculateTotal().transportFee.toFixed(2)}€
                  </p>
                </div>
              )}
            </div>
          )}
        </div>

        <div className="h-20"></div>
      </form>

          {/* Fixed Bottom Buttons */}
          <div className="fixed bottom-16 left-0 right-0 bg-white border-t border-gray-200 p-4 safe-area-bottom max-w-[390px] mx-auto z-40 shadow-lg">
            <div className="flex gap-3">
              <button
                type="button"
                onClick={() => navigate(`/transport/${id}`)}
                className="flex-1 border-2 border-gray-300 text-gray-700 py-4 rounded-xl font-semibold hover:bg-gray-50 transition-colors"
              >
                Back
              </button>
              <button
                onClick={handleSubmit}
                disabled={!weight || parseFloat(weight) <= 0}
                className={`flex-2 py-4 px-6 rounded-xl font-semibold transition-all flex items-center justify-center ${
                  !weight || parseFloat(weight) <= 0
                    ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                    : 'bg-[#0066FF] text-white hover:bg-[#0052CC] active:scale-98'
                }`}
              >
                <span>Proceed to Payment</span>
                {weight && parseFloat(weight) > 0 && trip && (
                  <span className="ml-2 bg-white/20 px-3 py-1 rounded-full text-sm">
                    {calculateTotal().total.toFixed(2)}€
                  </span>
                )}
              </button>
            </div>
          </div>
        </>
      ) : null}

      <BottomNav active="bookings" />
    </div>
  );
}
