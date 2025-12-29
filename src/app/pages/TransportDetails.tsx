import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Star, Phone, MessageCircle, MapPin, Clock, Package, CheckCircle2, Shield } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import apiService from '../services/api.service';

interface Trip {
  id: number;
  origin_city: string;
  origin_country: string;
  destination_city: string;
  destination_country: string;
  departure_date: string;
  arrival_date?: string;
  max_weight: number;
  available_weight: number;
  price_per_kg: number;
  description?: string;
  accepted_items?: string[];
  vehicle_info?: string;
  is_active: boolean;
  is_completed: boolean;
  transporter: {
    id: number;
    name: string;
    email: string;
    phone?: string;
    role: string;
    rating: number;
    total_trips: number;
    total_bookings: number;
    is_verified: boolean;
    avatar_url?: string;
  };
}

interface Review {
  id: number;
  rating: number;
  comment?: string;
  created_at: string;
  client: {
    name: string;
  };
}

export default function TransportDetails() {
  const navigate = useNavigate();
  const { id } = useParams();
  const [trip, setTrip] = useState<Trip | null>(null);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchTripDetails();
  }, [id]);

  const fetchTripDetails = async () => {
    if (!id) return;
    
    try {
      setLoading(true);
      setError('');
      const data = await apiService.getTripById(parseInt(id));
      setTrip(data);
      
      // Charger les avis du transporteur
      if (data.transporter?.id) {
        try {
          const reviewsData = await apiService.getTransporterReviews(data.transporter.id);
          setReviews(reviewsData);
        } catch (err) {
          console.error('Error fetching reviews:', err);
          setReviews([]);
        }
      }
    } catch (err: any) {
      setError(err.message || 'Failed to load trip details');
      console.error('Error fetching trip:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="inline-block animate-spin rounded-full h-12 w-12 border-4 border-gray-200 border-t-[#0066FF] mb-4"></div>
          <p className="text-gray-600">Loading trip details...</p>
        </div>
      </div>
    );
  }

  if (error || !trip) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center p-6">
          <p className="text-red-600 mb-4">{error || 'Trip not found'}</p>
          <button
            onClick={() => navigate('/search')}
            className="px-6 py-2 bg-[#0066FF] text-white rounded-xl"
          >
            Back to Search
          </button>
        </div>
      </div>
    );
  }

  const formattedDate = new Date(trip.departure_date).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  });
  
  const formattedTime = new Date(trip.departure_date).toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit'
  });

  const capacity = Math.round(((trip.max_weight - trip.available_weight) / trip.max_weight) * 100);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = Math.abs(now.getTime() - date.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays === 0) return "Aujourd'hui";
    if (diffDays === 1) return "Hier";
    if (diffDays < 7) return `Il y a ${diffDays} jours`;
    if (diffDays < 30) return `Il y a ${Math.floor(diffDays / 7)} semaines`;
    return date.toLocaleDateString('fr-FR', { month: 'short', day: 'numeric' });
  };

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
            👨
          </div>
          <div className="flex-1">
            <div className="flex items-center space-x-2 mb-1">
              <h1 className="text-xl">{trip.transporter.name}</h1>
              {trip.transporter.is_verified && (
                <CheckCircle2 className="w-5 h-5 text-blue-500 fill-current" />
              )}
            </div>
            <div className="flex items-center space-x-1 text-sm">
              <Star className="w-4 h-4 text-yellow-400 fill-current" />
              <span>{trip.transporter.rating?.toFixed(1) || '0.0'}</span>
              <span className="text-gray-500">({trip.transporter.total_trips || 0} trips)</span>
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
              <p>{trip.origin_city} → {trip.destination_city}</p>
            </div>
          </div>
          <div className="flex items-center space-x-3">
            <Clock className="w-5 h-5 text-gray-400" />
            <div>
              <p className="text-sm text-gray-500">Departure</p>
              <p>{formattedDate} at {formattedTime}</p>
            </div>
          </div>
          <div className="flex items-center space-x-3">
            <Package className="w-5 h-5 text-gray-400" />
            <div>
              <p className="text-sm text-gray-500">Available Capacity</p>
              <p>{trip.available_weight}kg / {trip.max_weight}kg ({capacity}% used)</p>
            </div>
          </div>
        </div>
      </div>

      {/* Pricing */}
      <div className="bg-white p-6 mb-4">
        <h2 className="mb-4">Pricing</h2>
        <div className="flex items-center justify-between">
          <span className="text-gray-600">Price per kg</span>
          <span className="text-2xl text-[#0066FF]">{trip.price_per_kg}€</span>
        </div>
      </div>

      {/* Description */}
      {trip.description && (
        <div className="bg-white p-6 mb-4">
          <h2 className="mb-4">Additional Information</h2>
          <p className="text-gray-700">{trip.description}</p>
        </div>
      )}

      {/* Transportable Items */}
      {trip.accepted_items && trip.accepted_items.length > 0 && (
        <div className="bg-white p-6 mb-4">
          <h2 className="mb-4">Items Transportable</h2>
          <div className="grid grid-cols-2 gap-2">
            {trip.accepted_items.map((item, index) => (
              <div key={index} className="flex items-center space-x-2">
                <CheckCircle2 className="w-4 h-4 text-green-500" />
                <span className="text-sm">{item}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Reviews */}
      <div className="bg-white p-6 mb-32">
        <h2 className="mb-4">Reviews</h2>
        {reviews.length > 0 ? (
          <div className="space-y-4">
            {reviews.map((review) => (
              <div key={review.id} className="border-b border-gray-100 last:border-0 pb-4 last:pb-0">
                <div className="flex items-center justify-between mb-2">
                  <p className="font-medium">{review.client?.name || 'Client'}</p>
                  <div className="flex items-center space-x-1">
                    {[...Array(5)].map((_, i) => (
                      <Star 
                        key={i} 
                        className={`w-4 h-4 ${
                          i < review.rating 
                            ? 'text-yellow-400 fill-current' 
                            : 'text-gray-300'
                        }`} 
                      />
                    ))}
                  </div>
                </div>
                {review.comment && (
                  <p className="text-sm text-gray-600 mb-1">{review.comment}</p>
                )}
                <p className="text-xs text-gray-400">{formatDate(review.created_at)}</p>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-gray-500 text-center py-4">Aucun avis pour le moment</p>
        )}
      </div>

      {/* Fixed Bottom Button */}
      <div className="fixed bottom-16 left-0 right-0 bg-white border-t border-gray-200 p-4 safe-area-bottom max-w-[390px] mx-auto z-40">
        <div className="flex items-center justify-between mb-3">
          <div>
            <p className="text-sm text-gray-500">Price per kg</p>
            <p className="text-2xl font-semibold text-[#0066FF]">{trip.price_per_kg}€</p>
          </div>
          <div className="text-right">
            <p className="text-sm text-gray-500">Available</p>
            <p className="font-semibold">{trip.available_weight}kg</p>
          </div>
        </div>
        <button
          onClick={() => navigate(`/booking/${id}`)}
          disabled={!trip.is_active || trip.available_weight <= 0}
          className={`w-full py-4 rounded-xl transition-all ${
            !trip.is_active || trip.available_weight <= 0
              ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
              : 'bg-[#0066FF] text-white active:scale-98 hover:bg-[#0052CC]'
          }`}
        >
          {!trip.is_active 
            ? 'Trip Not Available' 
            : trip.available_weight <= 0 
            ? 'No Capacity Available'
            : 'Book Now - Reserve Your Spot'
          }
        </button>
      </div>

      <BottomNav active="search" />
    </div>
  );
}
