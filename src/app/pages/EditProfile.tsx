import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Camera, User, Mail, Phone, MapPin, Save } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import apiService from '../services/api.service';

export default function EditProfile() {
  const navigate = useNavigate();
  const { user, updateUser } = useAuth();
  const { darkMode } = useTheme();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [photoPreview, setPhotoPreview] = useState<string | null>(() => {
    // Stocker la photo par ID utilisateur pour éviter la confusion entre client/transporteur
    const avatarKey = user?.id ? `userAvatar_${user.id}` : 'userAvatar';
    return user?.avatar || localStorage.getItem(avatarKey) || null;
  });
  
  const [formData, setFormData] = useState({
    name: user?.name || '',
    email: user?.email || '',
    phone: user?.phone || '',
    address: user?.address || '',
  });

  const handlePhotoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      // Créer un preview de l'image
      const reader = new FileReader();
      reader.onloadend = () => {
        const photoData = reader.result as string;
        setPhotoPreview(photoData);
        
        // Sauvegarder dans localStorage avec l'ID utilisateur
        if (user) {
          const avatarKey = `userAvatar_${user.id}`;
          localStorage.setItem(avatarKey, photoData);
          
          // Mettre à jour le user
          const updatedUser = { ...user, avatar: photoData };
          updateUser(updatedUser);
          localStorage.setItem('user', JSON.stringify(updatedUser));
          
          console.log(`📸 Photo sauvegardée pour l'utilisateur ${user.id} (${user.type})`);
        }
      };
      reader.readAsDataURL(file);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setSuccess('');

    try {
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error('Non connecté');
      }

      console.log('🔄 Mise à jour du profil...', { name: formData.name, phone: formData.phone });

      // Update profile via API
      const updatedUser = await apiService.updateUserProfile({
        name: formData.name,
        phone: formData.phone,
        address: formData.address,
      }, token);

      console.log('✅ Données reçues:', updatedUser);
      
      updateUser(updatedUser);
      setSuccess('Profil mis à jour avec succès !');
      
      setTimeout(() => {
        navigate(-1);
      }, 1500);
    } catch (err: any) {
      console.error('❌ Erreur complète:', err);
      setError(err.message || 'Erreur lors de la mise à jour');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={`min-h-screen pb-20 transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      {/* Header */}
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-4">
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate(-1)} className="p-2 hover:bg-white/10 rounded-full">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-semibold">Edit Profile</h1>
        </div>
      </div>

      {/* Profile Picture */}
      <div className="relative -mt-12 mb-6">
        <div className="flex justify-center">
          <div className="relative">
            <div className="w-24 h-24 bg-white rounded-full flex items-center justify-center text-4xl border-4 border-white shadow-lg overflow-hidden">
              {photoPreview ? (
                <img src={photoPreview} alt="Profile" className="w-full h-full object-cover" />
              ) : (
                <span>👤</span>
              )}
            </div>
            <label htmlFor="photo-upload" className="absolute bottom-0 right-0 w-8 h-8 bg-[#0066FF] text-white rounded-full flex items-center justify-center shadow-lg cursor-pointer hover:bg-[#0052CC] transition-colors">
              <Camera className="w-4 h-4" />
              <input
                id="photo-upload"
                type="file"
                accept="image/*"
                onChange={handlePhotoChange}
                className="hidden"
              />
            </label>
          </div>
        </div>
      </div>

      {/* Form */}
      <form onSubmit={handleSubmit} className="px-6 space-y-4">
        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl text-sm">
            {error}
          </div>
        )}
        
        {success && (
          <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl text-sm">
            {success}
          </div>
        )}

        <div>
          <label className={`block text-sm mb-2 font-medium ${
            darkMode ? 'text-gray-200' : 'text-gray-700'
          }`}>Full Name</label>
          <div className="relative">
            <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              name="name"
              value={formData.name}
              onChange={handleChange}
              className={`w-full pl-10 pr-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#0066FF] transition-colors ${
                darkMode 
                  ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' 
                  : 'bg-white border-gray-200 text-gray-900 placeholder-gray-400'
              }`}
              placeholder="Your full name"
              required
            />
          </div>
        </div>

        <div>
          <label className={`block text-sm mb-2 font-medium ${
            darkMode ? 'text-gray-200' : 'text-gray-700'
          }`}>Email</label>
          <div className="relative">
            <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="email"
              name="email"
              value={formData.email}
              className={`w-full pl-10 pr-4 py-3 rounded-xl border cursor-not-allowed ${
                darkMode 
                  ? 'bg-gray-800/50 border-gray-700 text-gray-400' 
                  : 'bg-gray-100 border-gray-200 text-gray-500'
              }`}
              disabled
            />
          </div>
          <p className={`text-xs mt-1 ${
            darkMode ? 'text-gray-400' : 'text-gray-500'
          }`}>Email cannot be changed</p>
        </div>

        <div>
          <label className={`block text-sm mb-2 font-medium ${
            darkMode ? 'text-gray-200' : 'text-gray-700'
          }`}>Phone Number</label>
          <div className="relative">
            <Phone className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="tel"
              name="phone"
              value={formData.phone}
              onChange={handleChange}
              className={`w-full pl-10 pr-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#0066FF] transition-colors ${
                darkMode 
                  ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' 
                  : 'bg-white border-gray-200 text-gray-900 placeholder-gray-400'
              }`}
              placeholder="+216 XX XXX XXX"
            />
          </div>
        </div>

        <div>
          <label className={`block text-sm mb-2 font-medium ${
            darkMode ? 'text-gray-200' : 'text-gray-700'
          }`}>Address (Optional)</label>
          <div className="relative">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              name="address"
              value={formData.address}
              onChange={handleChange}
              className={`w-full pl-10 pr-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#0066FF] transition-colors ${
                darkMode 
                  ? 'bg-gray-800 border-gray-700 text-white placeholder-gray-500' 
                  : 'bg-white border-gray-200 text-gray-900 placeholder-gray-400'
              }`}
              placeholder="Your address"
            />
          </div>
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full bg-[#0066FF] text-white py-4 rounded-xl flex items-center justify-center space-x-2 transition-all active:scale-98 disabled:opacity-50"
        >
          <Save className="w-5 h-5" />
          <span>{loading ? 'Saving...' : 'Save Changes'}</span>
        </button>
      </form>
    </div>
  );
}
