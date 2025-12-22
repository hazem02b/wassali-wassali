import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, MapPin, Calendar, Clock, DollarSign } from 'lucide-react';

export default function CreateTrip() {
  const navigate = useNavigate();
  const [negotiable, setNegotiable] = useState(false);
  const [insurance, setInsurance] = useState(false);
  const [tripType, setTripType] = useState('one-time');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/my-trips');
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-32">
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate('/transporter-dashboard')} className="p-2 hover:bg-gray-100 rounded-full">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl">Post New Trip</h1>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="p-6 space-y-6">
        {/* Route */}
        <div>
          <h2 className="mb-4">Route Information</h2>
          <div className="space-y-3">
            <div className="relative">
              <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <select className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#FF9500]" required>
                <option value="">From</option>
                <option value="tunis">Tunis</option>
                <option value="sfax">Sfax</option>
                <option value="sousse">Sousse</option>
              </select>
            </div>

            <div className="relative">
              <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <select className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#FF9500]" required>
                <option value="">To</option>
                <option value="paris">Paris</option>
                <option value="lyon">Lyon</option>
                <option value="marseille">Marseille</option>
              </select>
            </div>
          </div>
        </div>

        {/* Date & Time */}
        <div>
          <h2 className="mb-4">Schedule</h2>
          <div className="grid grid-cols-2 gap-3">
            <div className="relative">
              <Calendar className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="date"
                className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#FF9500]"
                required
              />
            </div>
            <div className="relative">
              <Clock className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="time"
                className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#FF9500]"
                required
              />
            </div>
          </div>
        </div>

        {/* Capacity & Pricing */}
        <div>
          <h2 className="mb-4">Capacity & Pricing</h2>
          <div className="space-y-3">
            <input
              type="number"
              className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#FF9500]"
              placeholder="Total Capacity (kg)"
              required
            />

            <div className="relative">
              <DollarSign className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="number"
                step="0.01"
                className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#FF9500]"
                placeholder="Price per kg (€)"
                required
              />
            </div>

            <div className="flex items-center space-x-2">
              <input
                type="checkbox"
                id="negotiable"
                checked={negotiable}
                onChange={(e) => setNegotiable(e.target.checked)}
                className="w-4 h-4 text-[#FF9500] rounded"
              />
              <label htmlFor="negotiable" className="text-sm">Price is negotiable</label>
            </div>
          </div>
        </div>

        {/* Trip Type */}
        <div>
          <h2 className="mb-4">Trip Type</h2>
          <div className="space-y-2">
            {['one-time', 'weekly', 'monthly'].map((type) => (
              <button
                key={type}
                type="button"
                onClick={() => setTripType(type)}
                className={`w-full p-4 rounded-xl border-2 text-left transition-colors ${
                  tripType === type ? 'border-[#FF9500] bg-orange-50' : 'border-gray-200 bg-white'
                }`}
              >
                <p className="capitalize">{type.replace('-', ' ')}</p>
              </button>
            ))}
          </div>
        </div>

        {/* Transportable Items */}
        <div>
          <h2 className="mb-4">Items You Can Transport</h2>
          <div className="grid grid-cols-2 gap-2">
            {['Documents', 'Clothes', 'Electronics', 'Food', 'Books', 'Furniture'].map((item) => (
              <label key={item} className="flex items-center space-x-2 p-3 bg-white rounded-lg border border-gray-200">
                <input type="checkbox" className="w-4 h-4 text-[#FF9500] rounded" />
                <span className="text-sm">{item}</span>
              </label>
            ))}
          </div>
        </div>

        {/* Special Notes */}
        <div>
          <label className="block mb-2">Special Notes (Optional)</label>
          <textarea
            className="w-full px-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#FF9500]"
            rows={3}
            placeholder="Any special notes..."
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
          <label htmlFor="insurance" className="text-sm">Offer insurance option to clients</label>
        </div>
      </form>

      {/* Fixed Bottom Buttons */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 safe-area-bottom max-w-[390px] mx-auto">
        <div className="flex gap-3">
          <button
            onClick={() => navigate('/transporter-dashboard')}
            className="flex-1 border border-gray-300 text-gray-700 py-4 rounded-xl"
          >
            Cancel
          </button>
          <button
            onClick={() => navigate('/my-trips')}
            className="flex-1 bg-gray-200 text-gray-700 py-4 rounded-xl"
          >
            Save Draft
          </button>
          <button
            onClick={handleSubmit}
            className="flex-1 bg-[#FF9500] text-white py-4 rounded-xl"
          >
            Post Trip
          </button>
        </div>
      </div>
    </div>
  );
}
