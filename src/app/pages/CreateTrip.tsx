import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, MapPin, Calendar, Clock, DollarSign } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';
import BottomNav from '../components/BottomNav';
import { useTrips } from '../contexts/TripsContext';
import apiService from '../services/api.service';

export default function CreateTrip() {
  const navigate = useNavigate();
  const { id } = useParams(); // Get trip ID from URL for editing
  const { user } = useAuth();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const { addTrip, updateTrip, refreshTrips } = useTrips();
  const [negotiable, setNegotiable] = useState(false);
  const [insurance, setInsurance] = useState(false);
  const [tripType, setTripType] = useState('one-time');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [isEditing, setIsEditing] = useState(false);
  
  // Form fields
  const [origin, setOrigin] = useState('');
  const [destination, setDestination] = useState('');
  const [departureDate, setDepartureDate] = useState('');
  const [departureTime, setDepartureTime] = useState('');
  const [availableWeight, setAvailableWeight] = useState('');
  const [pricePerKg, setPricePerKg] = useState('');
  const [vehicleType, setVehicleType] = useState('');
  const [description, setDescription] = useState('');
  const [acceptedItems, setAcceptedItems] = useState<string[]>([]);

  // Load trip data if editing
  useEffect(() => {
    if (id) {
      setIsEditing(true);
      loadTripData(id);
    }
  }, [id]);

  const loadTripData = async (tripId: string) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      const response = await fetch(`http://localhost:8000/api/v1/trips/${tripId}`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.ok) {
        const trip = await response.json();
        
        // Populate form with trip data
        setOrigin(`${trip.origin_city}, ${trip.origin_country}`);
        setDestination(`${trip.destination_city}, ${trip.destination_country}`);
        
        const datetime = new Date(trip.departure_date);
        setDepartureDate(datetime.toISOString().split('T')[0]);
        setDepartureTime(datetime.toTimeString().slice(0, 5));
        
        setAvailableWeight(trip.max_weight.toString());
        setPricePerKg(trip.price_per_kg.toString());
        setVehicleType(trip.vehicle_info || '');
        setDescription(trip.description || '');
        
        if (trip.accepted_items) {
          setAcceptedItems(trip.accepted_items);
        }
      }
    } catch (err) {
      console.error('Error loading trip:', err);
    }
  };

  const handleItemToggle = (item: string) => {
    setAcceptedItems(prev =>
      prev.includes(item)
        ? prev.filter(i => i !== item)
        : [...prev, item]
    );
  };
  
  // Helper styles for dark mode
  const inputClass = `w-full px-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-200 text-gray-900'}`;
  const inputWithIconClass = `w-full pl-12 pr-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white border-gray-200 text-gray-900'}`;
  const h2Class = `mb-4 ${darkMode ? 'text-white' : 'text-gray-900'}`;
  const labelClass = `block mb-2 ${darkMode ? 'text-gray-300' : 'text-gray-700'}`;
  const cardClass = `p-3 rounded-lg border ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`;
  const buttonOptionClass = (selected: boolean) => `w-full p-4 rounded-xl border-2 text-left transition-colors ${
    selected 
      ? 'border-[#FF9500] bg-orange-50 dark:bg-orange-900/30' 
      : `border-gray-200 ${darkMode ? 'bg-gray-800 border-gray-700 text-white' : 'bg-white text-gray-900'}`
  }`;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error('Vous devez être connecté');
      }

      // Combine date and time
      const departureDatetime = `${departureDate}T${departureTime}:00`;

      const tripData = {
        origin_city: origin.split(',')[0].trim(),
        origin_country: origin.includes(',') ? origin.split(',')[1].trim() : 'Morocco',
        destination_city: destination.split(',')[0].trim(),
        destination_country: destination.includes(',') ? destination.split(',')[1].trim() : 'France',
        departure_date: departureDatetime,
        max_weight: parseFloat(availableWeight),
        price_per_kg: parseFloat(pricePerKg),
        vehicle_info: vehicleType,
        description: description || `${origin} to ${destination} - ${vehicleType}`,
        accepted_items: acceptedItems.length > 0 ? acceptedItems : null,
      };

      console.log(isEditing ? 'Updating trip with data:' : 'Creating trip with data:', tripData);

      let result;
      if (isEditing && id) {
        // Update existing trip
        const response = await fetch(`http://localhost:8000/api/v1/trips/${id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify(tripData)
        });

        if (!response.ok) {
          throw new Error('Erreur lors de la mise à jour du trajet');
        }
        result = await response.json();
        updateTrip(parseInt(id), result);
        alert('Trajet mis à jour avec succès!');
      } else {
        // Create new trip
        result = await apiService.createTrip(tripData, token);
        addTrip(result);
        alert('Trajet créé avec succès!');
      }
      
      // Refresh trips to ensure synchronization
      await refreshTrips();
      console.log('Trip saved successfully:', result);
      navigate('/transporter-dashboard');
    } catch (err: any) {
      setError(err.message || 'Erreur lors de la sauvegarde du trajet');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={`min-h-screen pb-32 ${darkMode ? 'bg-gray-900' : 'bg-gray-50'}`}>
      <div className={`border-b p-4 sticky top-0 z-10 ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate('/transporter-dashboard')} className={`p-2 rounded-full ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}>
            <ArrowLeft className={`w-6 h-6 ${darkMode ? 'text-gray-300' : 'text-gray-900'}`} />
          </button>
          <h1 className={`text-xl ${darkMode ? 'text-white' : 'text-gray-900'}`}>{isEditing ? t('editTrip') : t('postNewTrip')}</h1>
        </div>
      </div>

      {error && (
        <div className="mx-6 mt-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded-xl text-sm">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="p-6 space-y-6">
        {/* Route */}
        <div>
          <h2 className={h2Class}>{t('routeInformation')}</h2>
          <div className="space-y-3">
            <div className="relative">
              <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                value={origin}
                onChange={(e) => setOrigin(e.target.value)}
                className={inputWithIconClass}
                placeholder={t('fromPlaceholder')}
                required
              />
            </div>

            <div className="relative">
              <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                value={destination}
                onChange={(e) => setDestination(e.target.value)}
                className={inputWithIconClass}
                placeholder={t('toPlaceholder')}
                required
              />
            </div>
          </div>
        </div>

        {/* Date & Time */}
        <div>
          <h2 className={h2Class}>{t('schedule')}</h2>
          <div className="grid grid-cols-2 gap-3">
            <div className="relative">
              <Calendar className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="date"
                value={departureDate}
                onChange={(e) => setDepartureDate(e.target.value)}
                min={new Date().toISOString().split('T')[0]}
                className={inputWithIconClass}
                required
              />
            </div>
            <div className="relative">
              <Clock className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="time"
                value={departureTime}
                onChange={(e) => setDepartureTime(e.target.value)}
                className={inputWithIconClass}
                required
              />
            </div>
          </div>
        </div>

        {/* Capacity & Pricing */}
        <div>
          <h2 className={h2Class}>{t('capacityPricing')}</h2>
          <div className="space-y-3">
            <input
              type="number"
              value={availableWeight}
              onChange={(e) => setAvailableWeight(e.target.value)}
              className={inputClass}
              placeholder={t('totalCapacity')}
              min="1"
              required
            />

            <div className="relative">
              <DollarSign className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="number"
                step="0.01"
                value={pricePerKg}
                onChange={(e) => setPricePerKg(e.target.value)}
                className={inputWithIconClass}
                placeholder={t('pricePerKg')}
                min="0.01"
                required
              />
            </div>

            <select
              value={vehicleType}
              onChange={(e) => setVehicleType(e.target.value)}
              className={inputClass}
              required
            >
              <option value="">{t('selectVehicleType')}</option>
              <option value="Car">{t('car')}</option>
              <option value="Van">{t('van')}</option>
              <option value="Truck">{t('truck')}</option>
              <option value="Motorcycle">{t('motorcycle')}</option>
            </select>

            <div className="flex items-center space-x-2">
              <input
                type="checkbox"
                id="negotiable"
                checked={negotiable}
                onChange={(e) => setNegotiable(e.target.checked)}
                className="w-4 h-4 text-[#FF9500] rounded"
              />
              <label htmlFor="negotiable" className={`text-sm ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>{t('priceNegotiable')}</label>
            </div>
          </div>
        </div>

        {/* Trip Type */}
        <div>
          <h2 className={h2Class}>{t('tripType')}</h2>
          <div className="space-y-2">
            {['one-time', 'weekly', 'monthly'].map((type) => (
              <button
                key={type}
                type="button"
                onClick={() => setTripType(type)}
                className={buttonOptionClass(tripType === type)}
              >
                <p className="capitalize">{t(type === 'one-time' ? 'oneTime' : type)}</p>
              </button>
            ))}
          </div>
        </div>

        {/* Transportable Items */}
        <div>
          <h2 className={h2Class}>{t('acceptedItems')}</h2>
          <div className="grid grid-cols-2 gap-2">
            {['Documents', 'Clothes', 'Electronics', 'Food', 'Books', 'Furniture'].map((item) => (
              <label key={item} className={`flex items-center space-x-2 ${cardClass}`}>
                <input 
                  type="checkbox" 
                  className="w-4 h-4 text-[#FF9500] rounded"
                  checked={acceptedItems.includes(item)}
                  onChange={() => handleItemToggle(item)}
                />
                <span className={`text-sm ${darkMode ? 'text-gray-300' : 'text-gray-900'}`}>{t(item.toLowerCase())}</span>
              </label>
            ))}
          </div>
        </div>

        {/* Special Notes */}
        <div>
          <label className={labelClass}>{t('additionalInfo')}</label>
          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className={inputClass}
            rows={3}
            placeholder={t('descriptionOptional')}
          />
        </div>

        {/* Insurance */}
        <div className="flex items-center space-x-2">
          <input
            type="checkbox"
            id="insurance"
            checked={insurance}
            onChange={(e) => setInsurance(e.target.checked)}
            className="w-4 h-4 text-[#FF9500] rounded"
          />
          <label htmlFor="insurance" className={`text-sm ${darkMode ? 'text-gray-300' : 'text-gray-700'}`}>{t('offerInsurance')}</label>
        </div>

        {/* Action Buttons */}
        <div className="flex gap-3 mt-8 pb-6">
          <button
            type="button"
            onClick={() => navigate('/transporter-dashboard')}
            className={`flex-1 border py-4 rounded-xl ${darkMode ? 'border-gray-600 text-gray-300 hover:bg-gray-700' : 'border-gray-300 text-gray-700 hover:bg-gray-100'}`}
          >
            {t('cancel')}
          </button>
          <button
            type="submit"
            disabled={loading}
            className="flex-1 bg-[#FF9500] text-white py-4 rounded-xl disabled:opacity-50 disabled:cursor-not-allowed hover:bg-[#E68600]"
          >
            {loading ? t('posting') : (isEditing ? t('updateTrip') : t('publishTrip'))}
          </button>
        </div>
      </form>

      <BottomNav active="create" />
    </div>
  );
}
