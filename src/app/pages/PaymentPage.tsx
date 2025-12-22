import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, CreditCard, Smartphone, Building2, Banknote } from 'lucide-react';

export default function PaymentPage() {
  const navigate = useNavigate();
  const [paymentMethod, setPaymentMethod] = useState<string>('wallet');

  const handlePayment = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/booking-confirmation');
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
            <span className="text-blue-100">Tunis → Paris</span>
            <span>240€</span>
          </div>
          <div className="flex justify-between text-xl pt-2 border-t border-blue-400">
            <span>Total</span>
            <span>240€</span>
          </div>
        </div>
      </div>

      <form onSubmit={handlePayment} className="px-6 space-y-6">
        <div>
          <h2 className="text-lg mb-4">Payment Method</h2>
          <div className="space-y-3">
            {[
              { id: 'wallet', label: 'Mobile Wallet', icon: Smartphone },
              { id: 'card', label: 'Credit/Debit Card', icon: CreditCard },
              { id: 'bank', label: 'Bank Transfer', icon: Building2 },
              { id: 'cash', label: 'Cash on Pickup', icon: Banknote },
            ].map(({ id, label, icon: Icon }) => (
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
                <Icon className="w-6 h-6 text-gray-600" />
                <span className="flex-1 text-left">{label}</span>
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
          <div className="space-y-4">
            <input
              type="text"
              className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
              placeholder="Card Number"
            />
            <div className="flex gap-3">
              <input
                type="text"
                className="flex-1 px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="MM/YY"
              />
              <input
                type="text"
                className="flex-1 px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="CVV"
              />
            </div>
          </div>
        )}

        {paymentMethod === 'wallet' && (
          <div>
            <input
              type="tel"
              className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
              placeholder="Phone Number"
            />
          </div>
        )}
      </form>

      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 safe-area-bottom max-w-[390px] mx-auto">
        <div className="flex gap-3">
          <button
            type="button"
            onClick={() => navigate(-1)}
            className="flex-1 border border-gray-300 text-gray-700 py-4 rounded-xl"
          >
            Back
          </button>
          <button
            onClick={handlePayment}
            className="flex-1 bg-[#0066FF] text-white py-4 rounded-xl transition-all active:scale-98"
          >
            Confirm & Pay
          </button>
        </div>
      </div>
    </div>
  );
}
