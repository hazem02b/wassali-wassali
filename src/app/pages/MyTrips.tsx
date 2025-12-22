import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, MapPin, Calendar, Package, Plus } from 'lucide-react';

export default function MyTrips() {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'active' | 'past'>('active');

  const activeTrips = [
    { id: 1, from: 'Tunis', to: 'Paris', date: 'Dec 25', capacity: 70, bookings: 3, price: '45€/kg' },
    { id: 2, from: 'Sfax', to: 'Lyon', date: 'Dec 28', capacity: 45, bookings: 2, price: '40€/kg' },
  ];

  const pastTrips = [
    { id: 3, from: 'Tunis', to: 'Marseille', date: 'Dec 15', capacity: 100, bookings: 5, price: '42€/kg' },
    { id: 4, from: 'Sousse', to: 'Paris', date: 'Dec 10', capacity: 90, bookings: 4, price: '48€/kg' },
  ];

  const trips = activeTab === 'active' ? activeTrips : pastTrips;

  return (
    <div className="min-h-screen bg-gray-50 pb-6">
      <div className="bg-white border-b border-gray-200 p-4 sticky top-0 z-10">
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate('/transporter-dashboard')} className="p-2 hover:bg-gray-100 rounded-full">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl">My Trips</h1>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white border-b border-gray-200 p-4">
        <div className="flex gap-2">
          <button
            onClick={() => setActiveTab('active')}
            className={`flex-1 py-3 rounded-xl transition-colors ${
              activeTab === 'active' ? 'bg-[#FF9500] text-white' : 'bg-gray-100 text-gray-600'
            }`}
          >
            Active
          </button>
          <button
            onClick={() => setActiveTab('past')}
            className={`flex-1 py-3 rounded-xl transition-colors ${
              activeTab === 'past' ? 'bg-[#FF9500] text-white' : 'bg-gray-100 text-gray-600'
            }`}
          >
            Past
          </button>
        </div>
      </div>

      <div className="p-4 space-y-3">
        {trips.map((trip) => (
          <div key={trip.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
            <div className="flex items-start justify-between mb-3">
              <div>
                <div className="flex items-center space-x-2 mb-2">
                  <MapPin className="w-4 h-4 text-gray-400" />
                  <span className="text-sm">{trip.from} → {trip.to}</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Calendar className="w-4 h-4 text-gray-400" />
                  <span className="text-sm text-gray-600">{trip.date}</span>
                </div>
              </div>
              <span className="text-lg text-[#FF9500]">{trip.price}</span>
            </div>

            {/* Capacity Bar */}
            <div className="mb-3">
              <div className="flex items-center justify-between text-xs text-gray-500 mb-1">
                <span>Capacity</span>
                <span>{trip.capacity}%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className="bg-[#FF9500] h-2 rounded-full"
                  style={{ width: `${trip.capacity}%` }}
                ></div>
              </div>
            </div>

            <div className="flex items-center justify-between text-sm mb-3">
              <div className="flex items-center space-x-2">
                <Package className="w-4 h-4 text-gray-400" />
                <span className="text-gray-600">{trip.bookings} bookings</span>
              </div>
            </div>

            {/* Actions */}
            <div className="flex gap-2">
              <button className="flex-1 py-2 border border-gray-200 text-gray-700 rounded-lg text-sm">
                View Bookings
              </button>
              {activeTab === 'active' && (
                <button className="flex-1 py-2 border border-[#FF9500] text-[#FF9500] rounded-lg text-sm">
                  Edit
                </button>
              )}
            </div>
          </div>
        ))}
      </div>

      {/* FAB */}
      <button
        onClick={() => navigate('/create-trip')}
        className="fixed bottom-6 right-6 w-14 h-14 bg-[#FF9500] text-white rounded-full shadow-lg flex items-center justify-center hover:bg-[#E68600] transition-colors z-10"
      >
        <Plus className="w-6 h-6" />
      </button>
    </div>
  );
}
