import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { ArrowLeft, Star } from 'lucide-react';
import apiService from '../services/api.service';

export default function LeaveReview() {
  const navigate = useNavigate();
  const location = useLocation();
  const { bookingId, transporterId, transporterName, tripDetails } = location.state || {};
  
  const [rating, setRating] = useState(0);
  const [hoveredRating, setHoveredRating] = useState(0);
  const [comment, setComment] = useState('');
  const [submitting, setSubmitting] = useState(false);

  if (!bookingId || !transporterId) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
        <div className="bg-white rounded-xl p-6 max-w-md w-full text-center">
          <p className="text-red-600 mb-4">❌ Informations manquantes</p>
          <button
            onClick={() => navigate('/my-bookings')}
            className="bg-[#0066FF] text-white px-6 py-2 rounded-lg hover:bg-[#0052CC]"
          >
            Retour aux réservations
          </button>
        </div>
      </div>
    );
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (rating === 0) {
      alert('Veuillez sélectionner une note');
      return;
    }

    try {
      setSubmitting(true);
      const token = localStorage.getItem('token');
      if (!token) {
        alert('Veuillez vous reconnecter');
        navigate('/login');
        return;
      }

      await apiService.createReview(
        {
          booking_id: bookingId,
          transporter_id: transporterId,
          rating,
          comment: comment.trim() || undefined
        },
        token
      );

      alert('✅ Merci pour votre avis !');
      navigate('/my-bookings');
    } catch (err: any) {
      alert('❌ Erreur: ' + (err.message || 'Impossible de soumettre l\'avis'));
      setSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <div className="flex items-center">
          <button
            onClick={() => navigate('/my-bookings')}
            className="p-2 hover:bg-gray-100 rounded-full"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-bold ml-3">Laisser un avis</h1>
        </div>
      </div>

      <div className="p-4">
        {/* Trip Info */}
        <div className="bg-white rounded-xl p-4 mb-4 shadow-sm border border-gray-100">
          <p className="text-sm text-gray-500 mb-1">Transporteur</p>
          <p className="font-semibold text-lg">{transporterName}</p>
          {tripDetails && (
            <p className="text-sm text-gray-600 mt-2">
              {tripDetails.origin} → {tripDetails.destination}
            </p>
          )}
        </div>

        {/* Review Form */}
        <form onSubmit={handleSubmit} className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
          {/* Rating */}
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-3">
              Votre note *
            </label>
            <div className="flex items-center justify-center space-x-2">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  type="button"
                  onClick={() => setRating(star)}
                  onMouseEnter={() => setHoveredRating(star)}
                  onMouseLeave={() => setHoveredRating(0)}
                  className="transition-transform hover:scale-110 focus:outline-none"
                >
                  <Star
                    className={`w-12 h-12 ${
                      star <= (hoveredRating || rating)
                        ? 'fill-amber-400 text-amber-400'
                        : 'text-gray-300'
                    }`}
                  />
                </button>
              ))}
            </div>
            {rating > 0 && (
              <p className="text-center mt-2 text-sm text-gray-600">
                {rating === 1 && '⭐ Très insatisfait'}
                {rating === 2 && '⭐⭐ Insatisfait'}
                {rating === 3 && '⭐⭐⭐ Moyen'}
                {rating === 4 && '⭐⭐⭐⭐ Satisfait'}
                {rating === 5 && '⭐⭐⭐⭐⭐ Excellent'}
              </p>
            )}
          </div>

          {/* Comment */}
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Votre commentaire (optionnel)
            </label>
            <textarea
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              placeholder="Partagez votre expérience avec ce transporteur..."
              className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#0066FF] focus:border-transparent resize-none"
              rows={5}
              maxLength={500}
            />
            <p className="text-xs text-gray-500 mt-1 text-right">
              {comment.length}/500 caractères
            </p>
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={submitting || rating === 0}
            className="w-full bg-[#0066FF] text-white py-3 rounded-lg font-semibold hover:bg-[#0052CC] transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed"
          >
            {submitting ? 'Envoi en cours...' : 'Publier l\'avis'}
          </button>
        </form>

        {/* Info */}
        <div className="mt-4 p-4 bg-blue-50 border border-blue-200 rounded-lg">
          <p className="text-xs text-blue-700">
            💡 <strong>Votre avis est important</strong><br />
            Il aide les autres utilisateurs à choisir les meilleurs transporteurs et encourage un service de qualité.
          </p>
        </div>
      </div>
    </div>
  );
}
