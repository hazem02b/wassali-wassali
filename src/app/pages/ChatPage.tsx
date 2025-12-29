import { useState, useEffect, useRef } from 'react';
import { useNavigate, useParams, useLocation } from 'react-router-dom';
import { ArrowLeft, Send, Phone, MoreVertical, Image as ImageIcon } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import apiService from '../services/api.service';

interface Message {
  id: number;
  sender_id: number;
  receiver_id: number;
  content: string;
  created_at: string;
  is_read: boolean;
}

export default function ChatPage() {
  const navigate = useNavigate();
  const { conversationId } = useParams<{ conversationId: string }>();
  const location = useLocation();
  const { user } = useAuth();
  const { darkMode } = useTheme();
  
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(true);
  const [otherUserName, setOtherUserName] = useState(location.state?.otherUserName || 'Utilisateur');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const otherUserId = location.state?.otherUserId;

  useEffect(() => {
    if (conversationId && user) {
      loadMessages();
    }
  }, [conversationId, user]);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const loadMessages = async () => {
    try {
      setLoading(true);
      const token = localStorage.getItem('token');
      if (!token || !conversationId) return;

      const data = await apiService.getConversationMessages(conversationId, token);
      setMessages(data);
      
      // Si le nom n'est pas dans location.state, récupérer les conversations
      if (!location.state?.otherUserName && data.length > 0) {
        try {
          const conversations = await apiService.getConversations(token);
          const currentConv = conversations.find((c: any) => c.conversation_id === conversationId);
          if (currentConv) {
            setOtherUserName(currentConv.other_user_name);
          }
        } catch (err) {
          console.error('Error loading conversation name:', err);
        }
      }
    } catch (error) {
      console.error('Error loading messages:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!message.trim() || !otherUserId) return;

    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      const newMessage = await apiService.sendMessage(otherUserId, message.trim(), token);
      setMessages([...messages, newMessage]);
      setMessage('');
    } catch (error) {
      console.error('Error sending message:', error);
    }
  };

  const formatTime = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className={`min-h-screen ${darkMode ? 'bg-gray-900' : 'bg-gray-50'} flex flex-col`}>
      {/* Header */}
      <div className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border-b p-4 sticky top-0 z-10`}>
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <button
              onClick={() => navigate(-1)}
              className={`p-2 rounded-full ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}
            >
              <ArrowLeft className={`w-6 h-6 ${darkMode ? 'text-white' : 'text-gray-900'}`} />
            </button>
            <div className="flex items-center space-x-3">
              <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                darkMode ? 'bg-gray-700' : 'bg-gray-100'
              }`}>
                <span className="text-lg">{otherUserName.charAt(0).toUpperCase()}</span>
              </div>
              <div>
                <h1 className={`text-sm font-semibold ${darkMode ? 'text-white' : 'text-gray-900'}`}>
                  {otherUserName}
                </h1>
                <p className="text-xs text-green-600">En ligne</p>
              </div>
            </div>
          </div>
          <div className="flex items-center space-x-2">
            <button className={`p-2 rounded-full ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}>
              <Phone className={`w-5 h-5 ${darkMode ? 'text-white' : 'text-gray-900'}`} />
            </button>
            <button className={`p-2 rounded-full ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}>
              <MoreVertical className={`w-5 h-5 ${darkMode ? 'text-white' : 'text-gray-900'}`} />
            </button>
          </div>
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {loading ? (
          <div className="flex items-center justify-center py-12">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0066FF]"></div>
          </div>
        ) : messages.length === 0 ? (
          <div className={`text-center py-12 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
            <p>Aucun message pour l'instant</p>
            <p className="text-sm mt-2">Envoyez un message pour commencer la conversation</p>
          </div>
        ) : (
          messages.map((msg) => {
            const isMe = msg.sender_id === Number(user?.id);
            return (
              <div
                key={msg.id}
                className={`flex ${isMe ? 'justify-end' : 'justify-start'}`}
              >
                <div
                  className={`max-w-[75%] rounded-2xl px-4 py-2 ${
                    isMe
                      ? 'bg-[#0066FF] text-white'
                      : darkMode
                      ? 'bg-gray-800 text-white'
                      : 'bg-white border border-gray-200'
                  }`}
                >
                  <p className="text-sm">{msg.content}</p>
                  <p
                    className={`text-xs mt-1 ${
                      isMe ? 'text-blue-100' : darkMode ? 'text-gray-400' : 'text-gray-400'
                    }`}
                  >
                    {formatTime(msg.created_at)}
                  </p>
                </div>
              </div>
            );
          })
        )}
        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <div className={`${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border-t p-4`}>
        <form onSubmit={handleSend} className="flex items-center space-x-2">
          <button
            type="button"
            className={`p-2 rounded-full flex-shrink-0 ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}
          >
            <ImageIcon className={`w-5 h-5 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`} />
          </button>
          <input
            type="text"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            className={`flex-1 px-4 py-3 rounded-full focus:outline-none focus:ring-2 focus:ring-[#0066FF] ${
              darkMode ? 'bg-gray-700 text-white' : 'bg-gray-100'
            }`}
            placeholder="Type a message..."
          />
          <button
            type="submit"
            className="p-3 bg-[#0066FF] text-white rounded-full flex-shrink-0 disabled:opacity-50 disabled:cursor-not-allowed"
            disabled={!message.trim()}
          >
            <Send className="w-5 h-5" />
          </button>
        </form>
      </div>
    </div>
  );
}
