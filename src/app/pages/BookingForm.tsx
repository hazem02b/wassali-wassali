import { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Upload, MapPin } from 'lucide-react';
import BottomNav from '../components/BottomNav';

export default function BookingForm() {
  const navigate = useNavigate();
  const { id } = useParams();
  const [savePickup, setSavePickup] = useState(false);
  const [saveDelivery, setSaveDelivery] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/payment');
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

      {/* Transport Summary */}
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6 mb-4">
        <h2 className="text-lg mb-2">Trip Summary</h2>
        <p className="text-blue-100">Tunis → Paris</p>
        <p className="text-sm text-blue-100">Dec 25, 2024 at 10:00 AM</p>
      </div>

      <form onSubmit={handleSubmit} className="px-6 space-y-6">
        {/* Package Details */}
        <div>
          <h2 className="text-lg mb-4">Package Details</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Item Description</label>
              <textarea
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                rows={3}
                placeholder="Describe your package..."
                required
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Weight (kg)</label>
              <input
                type="number"
                step="0.1"
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                placeholder="5.0"
                required
              />
            </div>

            <div>
              <label className="block text-sm mb-2">Photo (Optional)</label>
              <div className="w-full px-4 py-8 bg-white rounded-xl border-2 border-dashed border-gray-200 flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50">
                <Upload className="w-8 h-8 text-gray-400 mb-2" />
                <p className="text-sm text-gray-600">Upload package photo</p>
              </div>
            </div>

            <div>
              <label className="block text-sm mb-2">Special Notes (Optional)</label>
              <textarea
                className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                rows={2}
                placeholder="Any special instructions..."
              />
            </div>
          </div>
        </div>

        {/* Addresses */}
        <div>
          <h2 className="text-lg mb-4">Addresses</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm mb-2">Pickup Address</label>
              <div className="relative">
                <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                  placeholder="Enter pickup address"
                  required
                />
              </div>
              <div className="flex items-center space-x-2 mt-2">
                <input
                  type="checkbox"
                  id="save-pickup"
                  checked={savePickup}
                  onChange={(e) => setSavePickup(e.target.checked)}
                  className="w-4 h-4 text-[#0066FF] rounded"
                />
                <label htmlFor="save-pickup" className="text-sm text-gray-600">
                  Save this address
                </label>
              </div>
            </div>

            <div>
              <label className="block text-sm mb-2">Delivery Address</label>
              <div className="relative">
                <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
                  placeholder="Enter delivery address"
                  required
                />
              </div>
              <div className="flex items-center space-x-2 mt-2">
                <input
                  type="checkbox"
                  id="save-delivery"
                  checked={saveDelivery}
                  onChange={(e) => setSaveDelivery(e.target.checked)}
                  className="w-4 h-4 text-[#0066FF] rounded"
                />
                <label htmlFor="save-delivery" className="text-sm text-gray-600">
                  Save this address
                </label>
              </div>
            </div>
          </div>
        </div>

        {/* Reservation Summary */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h3 className="mb-3">Reservation Summary</h3>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between">
              <span className="text-gray-600">Price per kg</span>
              <span>45€</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Estimated weight</span>
              <span>5 kg</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Subtotal</span>
              <span>225€</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Service fee</span>
              <span>15€</span>
            </div>
            <div className="border-t border-gray-200 pt-2 mt-2"></div>
            <div className="flex justify-between text-lg">
              <span>Total</span>
              <span className="text-[#0066FF]">240€</span>
            </div>
          </div>
        </div>

        <div className="h-20"></div>
      </form>

      {/* Fixed Bottom Buttons */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 safe-area-bottom max-w-[390px] mx-auto">
        <div className="flex gap-3">
          <button
            type="button"
            onClick={() => navigate(`/transport/${id}`)}
            className="flex-1 border border-gray-300 text-gray-700 py-4 rounded-xl"
          >
            Back
          </button>
          <button
            onClick={handleSubmit}
            className="flex-1 bg-[#0066FF] text-white py-4 rounded-xl transition-all active:scale-98"
          >
            Proceed to Payment
          </button>
        </div>
      </div>

      <BottomNav active="bookings" />
    </div>
  );
}
