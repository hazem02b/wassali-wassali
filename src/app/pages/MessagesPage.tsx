import { useNavigate } from 'react-router-dom';
import { ArrowLeft, MessageCircle, Search } from 'lucide-react';
import { useState, useEffect } from 'react';
import BottomNav from '../components/BottomNav';
import { useLanguage } from '../contexts/LanguageContext';
import { useConversations } from '../hooks/useConversations';
import { useTheme } from '../contexts/ThemeContext';
import apiService from '../services/api.service';
import { useAuth } from '../contexts/AuthContext';

interface User {
  id: number;
  name: string;
  email: string;
  role: string;
}

export default function MessagesPage() {
  const navigate = useNavigate();
  const { t } = useLanguage();
  const { darkMode } = useTheme();
  const { user } = useAuth();
  const { conversations, loading, markAsRead } = useConversations();
  const [searchQuery, setSearchQuery] = useState('');
  const [availableUsers, setAvailableUsers] = useState<User[]>([]);
  const [searchLoading, setSearchLoading] = useState(false);

  // Charger les utilisateurs disponibles quand la recherche change
  useEffect(() => {
    const loadUsers = async () => {
      if (searchQuery.trim().length > 0) {
        try {
          setSearchLoading(true);
          const token = localStorage.getItem('token');
          if (token) {
            const users = await apiService.getAvailableUsers(token);
            setAvailableUsers(users);
          }
        } catch (error) {
          console.error('Error loading users:', error);
        } finally {
          setSearchLoading(false);
        }
      } else {
        setAvailableUsers([]);
      }
    };
    loadUsers();
  }, [searchQuery]);

  const handleSelectUser = (selectedUser: User) => {
    const userIds = [Number(user?.id), selectedUser.id].sort();
    const conversationId = `${userIds[0]}_${userIds[1]}`;
    navigate(`/chat/${conversationId}`, {
      state: {
        otherUserId: selectedUser.id,
        otherUserName: selectedUser.name
      }
    });
  };

  const filteredUsers = availableUsers.filter(u =>
    u.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    u.email.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className={`min-h-screen pb-20 transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      {/* Header */}
      <div className={`border-b p-4 sticky top-0 z-10 transition-colors ${
        darkMode 
          ? 'bg-gray-800 border-gray-700' 
          : 'bg-white border-gray-200'
      }`}>
        <div className="flex items-center space-x-3 mb-4">
          <button
            onClick={() => navigate('/home')}
            className={`p-2 rounded-full transition-colors ${
              darkMode 
                ? 'hover:bg-gray-700 text-white' 
                : 'hover:bg-gray-100 text-gray-900'
            }`}
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className={`text-xl ${darkMode ? 'text-white' : 'text-gray-900'}`}>
            {t('messages')}
          </h1>
        </div>

        {/* Search */}
        <div className="relative">
          <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className={`w-full pl-12 pr-4 py-3 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0066FF] transition-colors ${
              darkMode 
                ? 'bg-gray-700 text-white placeholder-gray-400' 
                : 'bg-gray-100 text-gray-900 placeholder-gray-500'
            }`}
            placeholder={t('searchConversations')}
          />
        </div>
      </div>

      {/* Loading State */}
      {loading && !searchQuery && (
        <div className="flex items-center justify-center h-96">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#0066FF]"></div>
        </div>
      )}

      {/* Search Results - Users */}
      {searchQuery && (
        <div>
          {searchLoading ? (
            <div className="flex items-center justify-center h-96">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#0066FF]"></div>
            </div>
          ) : filteredUsers.length > 0 ? (
            <div className={`divide-y ${darkMode ? 'divide-gray-700' : 'divide-gray-100'}`}>
              {filteredUsers.map((selectedUser) => (
                <button
                  key={selectedUser.id}
                  onClick={() => handleSelectUser(selectedUser)}
                  className={`w-full flex items-center space-x-3 p-4 transition-colors ${
                    darkMode 
                      ? 'bg-gray-800 hover:bg-gray-750' 
                      : 'bg-white hover:bg-gray-50'
                  }`}
                >
                  <div className="w-12 h-12 rounded-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white font-semibold text-xl">
                    {selectedUser.name.charAt(0).toUpperCase()}
                  </div>
                  <div className="flex-1 text-left">
                    <p className={`font-semibold ${darkMode ? 'text-white' : 'text-gray-900'}`}>
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
                </button>
              ))}
            </div>
          ) : (
            <div className={`flex flex-col items-center justify-center h-96 ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`}>
              <Search className="w-16 h-16 mb-4" />
              <p>Aucun résultat pour "{searchQuery}"</p>
            </div>
          )}
        </div>
      )}

      {/* Conversations List */}
      {!loading && !searchQuery && conversations.length > 0 && (
        <div className={`divide-y ${darkMode ? 'divide-gray-700' : 'divide-gray-100'}`}>
          {conversations.map((conv) => (
            <button
              key={conv.id}
              onClick={() => {
                markAsRead(conv.id);
                navigate(`/chat/${conv.id}`, {
                  state: {
                    otherUserId: conv.userId,
                    otherUserName: conv.name
                  }
                });
              }}
              className={`w-full flex items-center space-x-3 p-4 transition-colors ${
                darkMode 
                  ? 'bg-gray-800 hover:bg-gray-750' 
                  : 'bg-white hover:bg-gray-50'
              }`}
            >
              <div className="relative">
                <div className={`w-12 h-12 rounded-full flex items-center justify-center text-xl ${
                  darkMode ? 'bg-gray-700' : 'bg-gray-100'
                }`}>
                  {conv.avatar}
                </div>
                {conv.online && (
                  <div className={`absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 rounded-full ${
                    darkMode ? 'border-gray-800' : 'border-white'
                  }`}></div>
                )}
              </div>

              <div className="flex-1 text-left min-w-0">
                <div className="flex items-center justify-between mb-1">
                  <p className={`font-semibold truncate ${
                    darkMode ? 'text-white' : 'text-gray-900'
                  }`}>{conv.name}</p>
                  <span className="text-xs text-gray-400 flex-shrink-0 ml-2">
                    {conv.timestamp}
                  </span>
                </div>
                <p className={`text-sm truncate ${
                  darkMode ? 'text-gray-400' : 'text-gray-600'
                }`}>{conv.lastMessage}</p>
              </div>

              {conv.unread > 0 && (
                <div className="flex-shrink-0">
                  <div className="w-6 h-6 bg-[#0066FF] text-white rounded-full flex items-center justify-center text-xs">
                    {conv.unread}
                  </div>
                </div>
              )}
            </button>
          ))}
        </div>
      )}

      {/* Empty State */}
      {!loading && !searchQuery && conversations.length === 0 && (
        <div className={`flex flex-col items-center justify-center h-96 ${
          darkMode ? 'text-gray-500' : 'text-gray-400'
        }`}>
          <MessageCircle className="w-16 h-16 mb-4" />
          <p>{t('noMessages') || 'No messages yet'}</p>
          <p className="text-sm mt-2">{t('startConversation') || 'Start a conversation with a transporter'}</p>
        </div>
      )}

      <BottomNav active="messages" />
    </div>
  );
}
