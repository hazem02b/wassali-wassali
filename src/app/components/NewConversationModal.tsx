import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { X, Search } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import apiService from '../services/api.service';

interface User {
  id: number;
  name: string;
  email: string;
  role: string;
}

interface NewConversationModalProps {
  onClose: () => void;
}

export default function NewConversationModal({ onClose }: NewConversationModalProps) {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { darkMode } = useTheme();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    try {
      setLoading(true);
      const token = localStorage.getItem('token');
      if (!token) return;

      const response = await apiService.getAvailableUsers(token);
      setUsers(response);
    } catch (error) {
      console.error('Error loading users:', error);
    } finally {
      setLoading(false);
    }
  };

  const filteredUsers = users.filter(u =>
    u.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    u.email.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleSelectUser = async (selectedUser: User) => {
    try {
      const token = localStorage.getItem('token');
      if (!token || !user) return;

      // Créer conversation_id
      const userIds = [Number(user.id), selectedUser.id].sort();
      const conversationId = `${userIds[0]}_${userIds[1]}`;

      // Naviguer vers la page de chat
      navigate(`/chat/${conversationId}`, {
        state: {
          otherUserId: selectedUser.id,
          otherUserName: selectedUser.name
        }
      });
      onClose();
    } catch (error) {
      console.error('Error creating conversation:', error);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className={`w-full max-w-md rounded-lg shadow-xl ${darkMode ? 'bg-gray-800' : 'bg-white'}`}>
        {/* Header */}
        <div className={`flex items-center justify-between p-4 border-b ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
          <h2 className={`text-lg font-semibold ${darkMode ? 'text-white' : 'text-gray-900'}`}>
            Nouveau message
          </h2>
          <button
            onClick={onClose}
            className={`p-2 rounded-full ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}
          >
            <X className={`w-5 h-5 ${darkMode ? 'text-white' : 'text-gray-900'}`} />
          </button>
        </div>

        {/* Search */}
        <div className="p-4">
          <div className="relative">
            <Search className={`absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`} />
            <input
              type="text"
              placeholder="Rechercher un utilisateur..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className={`w-full pl-10 pr-4 py-2 rounded-lg ${
                darkMode
                  ? 'bg-gray-700 text-white placeholder-gray-400'
                  : 'bg-gray-100 text-gray-900 placeholder-gray-500'
              } focus:outline-none focus:ring-2 focus:ring-[#0066FF]`}
            />
          </div>
        </div>

        {/* Users List */}
        <div className={`max-h-96 overflow-y-auto ${darkMode ? 'divide-gray-700' : 'divide-gray-200'} divide-y`}>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0066FF]"></div>
            </div>
          ) : filteredUsers.length === 0 ? (
            <div className={`text-center py-12 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
              <p>Aucun utilisateur trouvé</p>
            </div>
          ) : (
            filteredUsers.map((selectedUser) => (
              <button
                key={selectedUser.id}
                onClick={() => handleSelectUser(selectedUser)}
                className={`w-full p-4 text-left transition-colors ${
                  darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'
                }`}
              >
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white font-semibold">
                    {selectedUser.name.charAt(0).toUpperCase()}
                  </div>
                  <div className="flex-1">
                    <p className={`font-medium ${darkMode ? 'text-white' : 'text-gray-900'}`}>
                      {selectedUser.name}
                    </p>
                    <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                      {selectedUser.email}
                    </p>
                  </div>
                  <span className={`text-xs px-2 py-1 rounded ${
                    selectedUser.role === 'transporter'
                      ? 'bg-orange-100 text-orange-800'
                      : 'bg-blue-100 text-blue-800'
                  }`}>
                    {selectedUser.role === 'transporter' ? 'Transporteur' : 'Client'}
                  </span>
                </div>
              </button>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
