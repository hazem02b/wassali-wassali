import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { ArrowLeft, CreditCard, Smartphone, Building2, Banknote, Shield, CheckCircle } from 'lucide-react';
import apiService from '../services/api.service';

interface PaymentPageState {
  bookingId: number;
  totalPrice: number;
  trackingNumber: string;
  tripDetails: {
    origin: string;
    destination: string;
  };
}

export default function PaymentPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const state = location.state as PaymentPageState | null;
  
  const [paymentMethod, setPaymentMethod] = useState<string>('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [cardNumber, setCardNumber] = useState('');
  const [expiryDate, setExpiryDate] = useState('');
  const [cvv, setCvv] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [savePayment, setSavePayment] = useState(false);

  if (!state) {
    navigate('/my-bookings');
    return null;
  }

  const handlePayment = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error('Vous devez être connecté');
      }

      // Vérifier que la réservation a été confirmée par le transporteur
      const bookings = await apiService.getMyBookings(token);
      const currentBooking = bookings.find((b: any) => b.id === state.bookingId);
      
      if (!currentBooking) {
        throw new Error('Booking not found');
      }
      
      if (currentBooking.status.toLowerCase() === 'pending') {
        throw new Error('Please wait for transporter approval before payment');
      }
      
      if (currentBooking.status.toLowerCase() === 'cancelled') {
        throw new Error('This booking was rejected by the transporter');
      }

      // Simuler le paiement (dans une vraie application, on intégrerait Stripe ou PayPal)
      await new Promise(resolve => setTimeout(resolve, 2000));

      // Mettre à jour le statut de paiement du booking
      await apiService.updateBooking(state.bookingId, {
        is_paid: true,
        payment_method: paymentMethod
      }, token);

      // Rediriger vers la page de confirmation
      navigate('/booking-confirmation', { 
        state: { 
          bookingId: state.bookingId,
          trackingNumber: state.trackingNumber,
          totalPrice: state.totalPrice,
          tripDetails: state.tripDetails,
          paymentMethod,
          paymentStatus: 'success' 
        } 
      });
    } catch (err: any) {
      setError(err.message || 'Erreur lors du paiement');
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-32">
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <button onClick={() => navigate(-1)} className="p-2 hover:bg-gray-100 rounded-full inline-flex">
          <ArrowLeft className="w-6 h-6" />
        </button>
      </div>

      {/* Order Summary */}
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6 mb-6">
        <h2 className="text-lg mb-4">Order Summary</h2>
        <div className="space-y-2 text-sm">
          <div className="flex justify-between">
            <span className="text-blue-100">Route</span>
            <span>{state.tripDetails.origin} → {state.tripDetails.destination}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-blue-100">Tracking Number</span>
            <span className="font-mono">{state.trackingNumber}</span>
          </div>
          <div className="flex justify-between text-xl pt-2 border-t border-blue-400">
            <span>Total</span>
            <span>{state.totalPrice.toFixed(2)}€</span>
          </div>
        </div>
      </div>

      <form onSubmit={handlePayment} className="px-6 space-y-6">
        {/* Error Message */}
        {error && (
          <div className="p-4 bg-red-50 border border-red-200 text-red-700 rounded-xl">
            {error}
          </div>
        )}
        {/* Security Badge */}
        <div className="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center space-x-3">
          <Shield className="w-6 h-6 text-green-600" />
          <div className="flex-1">
            <p className="text-sm font-medium text-green-800">Secure Payment</p>
            <p className="text-xs text-green-600">Your payment information is encrypted</p>
          </div>
        </div>

        <div>
          <h2 className="text-lg mb-4">Payment Method</h2>
          <div className="space-y-3">
            {[
              { id: 'wallet', label: 'Mobile Wallet', subLabel: 'D17, Ooredoo Money', icon: Smartphone },
              { id: 'card', label: 'Credit/Debit Card', subLabel: 'Visa, Mastercard', icon: CreditCard },
              { id: 'bank', label: 'Bank Transfer', subLabel: '1-2 business days', icon: Building2 },
              { id: 'cash', label: 'Cash on Pickup', subLabel: 'Pay when collecting', icon: Banknote },
            ].map(({ id, label, subLabel, icon: Icon }) => (
              <button
                key={id}
                type="button"
                onClick={() => setPaymentMethod(id)}
                className={`w-full flex items-center space-x-4 p-4 rounded-xl border-2 transition-colors ${
                  paymentMethod === id
                    ? 'border-[#0066FF] bg-blue-50'
                    : 'border-gray-200 bg-white hover:border-gray-300'
                }`}
              >
                <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                  paymentMethod === id ? 'bg-[#0066FF] text-white' : 'bg-gray-100 text-gray-600'
                }`}>
                  <Icon className="w-6 h-6" />
                </div>
                <div className="flex-1 text-left">
                  <p className="font-medium">{label}</p>
                  <p className="text-xs text-gray-500">{subLabel}</p>
                </div>
                <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${
                  paymentMethod === id ? 'border-[#0066FF]' : 'border-gray-300'
                }`}>
                  {paymentMethod === id && (
                    <div className="w-3 h-3 rounded-full bg-[#0066FF]"></div>
                  )}
                </div>
              </button>
            ))}
          </div>
        </div>

        {paymentMethod === 'card' && (
          <div className="space-y-4 animate-fadeIn">
            <div>
              <label className="block text-sm text-gray-700 mb-2">Card Number</label>
              <input
                type="text"
                value={cardNumber}
                onChange={(e) => {
                  const value = e.target.value.replace(/\s/g, '').replace(/(\d{4})/g, '$1 ').trim();
                  setCardNumber(value);
                }}
                maxLength={19}
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="1234 5678 9012 3456"
                required
              />
            </div>
            <div className="flex gap-3">
              <div className="flex-1">
                <label className="block text-sm text-gray-700 mb-2">Expiry Date</label>
                <input
                  type="text"
                  value={expiryDate}
                  onChange={(e) => {
                    let value = e.target.value.replace(/\D/g, '');
                    if (value.length >= 2) {
                      value = value.slice(0, 2) + '/' + value.slice(2, 4);
                    }
                    setExpiryDate(value);
                  }}
                  maxLength={5}
                  className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                  placeholder="MM/YY"
                  required
                />
              </div>
              <div className="flex-1">
                <label className="block text-sm text-gray-700 mb-2">CVV</label>
                <input
                  type="password"
                  value={cvv}
                  onChange={(e) => setCvv(e.target.value.replace(/\D/g, '').slice(0, 3))}
                  maxLength={3}
                  className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                  placeholder="123"
                  required
                />
              </div>
            </div>
            <div className="flex items-center space-x-2">
              <input
                type="checkbox"
                id="saveCard"
                checked={savePayment}
                onChange={(e) => setSavePayment(e.target.checked)}
                className="w-4 h-4 text-[#0066FF] border-gray-300 rounded focus:ring-[#0066FF]"
              />
              <label htmlFor="saveCard" className="text-sm text-gray-700">
                Save this card for future payments
              </label>
            </div>
          </div>
        )}

        {paymentMethod === 'wallet' && (
          <div className="animate-fadeIn">
            <label className="block text-sm text-gray-700 mb-2">Phone Number</label>
            <input
              type="tel"
              value={phoneNumber}
              onChange={(e) => setPhoneNumber(e.target.value)}
              className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
              placeholder="+216 XX XXX XXX"
              required
            />
            <p className="text-xs text-gray-500 mt-2">
              You'll receive a confirmation SMS to complete the payment
            </p>
          </div>
        )}

        {paymentMethod === 'bank' && (
          <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4 animate-fadeIn">
            <p className="text-sm text-yellow-800 mb-2 font-medium">Bank Transfer Instructions</p>
            <div className="text-xs text-yellow-700 space-y-1">
              <p>Bank: Banque de Tunisie</p>
              <p>Account: TN59 1000 6035 0000 0000 0000 00</p>
              <p>Reference: WAS{Math.random().toString(36).substr(2, 9).toUpperCase()}</p>
            </div>
          </div>
        )}

        {paymentMethod === 'cash' && (
          <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 animate-fadeIn">
            <div className="flex items-start space-x-3">
              <CheckCircle className="w-5 h-5 text-blue-600 mt-0.5" />
              <div className="text-sm text-blue-800">
                <p className="font-medium mb-1">Cash Payment</p>
                <p className="text-blue-700">Pay directly to the transporter when they collect your package. Make sure to get a receipt.</p>
              </div>
            </div>
          </div>
        )}
      </form>

      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 safe-area-bottom max-w-[390px] mx-auto">
        <div className="flex gap-3">
          <button
            type="button"
            onClick={() => navigate(-1)}
            className="flex-1 border border-gray-300 text-gray-700 py-4 rounded-xl transition-colors hover:bg-gray-50"
            disabled={loading}
          >
            Back
          </button>
          <button
            onClick={handlePayment}
            disabled={!paymentMethod || loading}
            className="flex-1 bg-[#0066FF] text-white py-4 rounded-xl transition-all active:scale-98 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? (
              <div className="flex items-center justify-center space-x-2">
                <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                <span>Processing...</span>
              </div>
            ) : (
              `Pay ${state.totalPrice.toFixed(2)}€`
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
