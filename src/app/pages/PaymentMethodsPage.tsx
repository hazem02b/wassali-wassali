import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, CreditCard, Smartphone, Building2, Plus, Trash2 } from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';

interface PaymentMethod {
  id: string;
  type: 'card' | 'd17' | 'bank';
  name: string;
  details: string;
  isDefault?: boolean;
}

export default function PaymentMethodsPage() {
  const navigate = useNavigate();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  
  const [paymentMethods, setPaymentMethods] = useState<PaymentMethod[]>(() => {
    const saved = localStorage.getItem('paymentMethods');
    return saved ? JSON.parse(saved) : [
      {
        id: '1',
        type: 'd17',
        name: 'D17 Mobile Money',
        details: '+216 XX XXX XXX',
        isDefault: true,
      },
    ];
  });

  const [showAddModal, setShowAddModal] = useState(false);
  const [newMethod, setNewMethod] = useState({
    type: 'd17' as 'card' | 'd17' | 'bank',
    details: '',
  });

  const handleAddPaymentMethod = () => {
    if (!newMethod.details.trim()) return;

    const method: PaymentMethod = {
      id: Date.now().toString(),
      type: newMethod.type,
      name: getMethodName(newMethod.type),
      details: newMethod.details,
      isDefault: paymentMethods.length === 0,
    };

    const updated = [...paymentMethods, method];
    setPaymentMethods(updated);
    localStorage.setItem('paymentMethods', JSON.stringify(updated));
    setShowAddModal(false);
    setNewMethod({ type: 'd17', details: '' });
  };

  const handleDelete = (id: string) => {
    const updated = paymentMethods.filter(m => m.id !== id);
    setPaymentMethods(updated);
    localStorage.setItem('paymentMethods', JSON.stringify(updated));
  };

  const handleSetDefault = (id: string) => {
    const updated = paymentMethods.map(m => ({
      ...m,
      isDefault: m.id === id,
    }));
    setPaymentMethods(updated);
    localStorage.setItem('paymentMethods', JSON.stringify(updated));
  };

  function getMethodName(type: string) {
    switch (type) {
      case 'd17':
        return t('d17MobileMoney');
      case 'card':
        return t('creditCard');
      case 'bank':
        return t('bankTransfer');
      default:
        return '';
    }
  }

  function getMethodIcon(type: string) {
    switch (type) {
      case 'd17':
        return <Smartphone className="w-5 h-5 text-green-600" />;
      case 'card':
        return <CreditCard className="w-5 h-5 text-blue-600" />;
      case 'bank':
        return <Building2 className="w-5 h-5 text-purple-600" />;
      default:
        return null;
    }
  }

  return (
    <div className={`min-h-screen transition-colors ${
      darkMode ? 'bg-gray-900' : 'bg-gray-50'
    }`}>
      {/* Header */}
      <div className={`border-b p-4 sticky top-0 z-10 transition-colors ${
        darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
      }`}>
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <button onClick={() => navigate(-1)} className={`p-2 rounded-full ${
              darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
            }`}>
              <ArrowLeft className={`w-6 h-6 ${
                darkMode ? 'text-white' : 'text-gray-900'
              }`} />
            </button>
            <h1 className={`text-xl font-semibold ${
              darkMode ? 'text-white' : 'text-gray-900'
            }`}>{t('paymentMethods')}</h1>
          </div>
          <button
            onClick={() => setShowAddModal(true)}
            className="p-2 bg-[#0066FF] text-white rounded-full hover:opacity-90 transition-opacity"
          >
            <Plus className="w-5 h-5" />
          </button>
        </div>
      </div>

      {/* Payment Methods List */}
      <div className="p-6 space-y-3">
        {paymentMethods.length === 0 ? (
          <div className={`text-center py-12 rounded-xl border ${
            darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
          }`}>
            <CreditCard className={`w-16 h-16 mx-auto mb-4 ${
              darkMode ? 'text-gray-600' : 'text-gray-300'
            }`} />
            <p className={`mb-2 ${
              darkMode ? 'text-gray-300' : 'text-gray-600'
            }`}>
              {t('noPaymentMethods')}
            </p>
            <p className={`text-sm ${
              darkMode ? 'text-gray-500' : 'text-gray-400'
            }`}>
              {t('addFirstPaymentMethod')}
            </p>
          </div>
        ) : (
          paymentMethods.map((method) => (
            <div
              key={method.id}
              className={`rounded-xl p-4 border transition-colors ${
                darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
              } ${method.isDefault ? 'ring-2 ring-[#0066FF]' : ''}`}
            >
              <div className="flex items-start justify-between">
                <div className="flex items-center space-x-3">
                  <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                    method.type === 'd17' ? 'bg-green-100' :
                    method.type === 'card' ? 'bg-blue-100' :
                    'bg-purple-100'
                  }`}>
                    {getMethodIcon(method.type)}
                  </div>
                  <div>
                    <p className={`font-medium ${
                      darkMode ? 'text-white' : 'text-gray-900'
                    }`}>{method.name}</p>
                    <p className={`text-sm ${
                      darkMode ? 'text-gray-400' : 'text-gray-600'
                    }`}>{method.details}</p>
                    {method.isDefault && (
                      <span className="inline-block mt-1 px-2 py-0.5 bg-[#0066FF] text-white text-xs rounded">
                        {t('defaultMethod')}
                      </span>
                    )}
                  </div>
                </div>
                <div className="flex space-x-2">
                  {!method.isDefault && (
                    <button
                      onClick={() => handleSetDefault(method.id)}
                      className={`px-3 py-1 rounded-lg text-xs transition-colors ${
                        darkMode 
                          ? 'bg-gray-700 text-gray-300 hover:bg-gray-600' 
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      {t('setAsDefault')}
                    </button>
                  )}
                  <button
                    onClick={() => handleDelete(method.id)}
                    className={`p-2 rounded-lg transition-colors ${
                      darkMode 
                        ? 'hover:bg-red-900/20 text-red-400' 
                        : 'hover:bg-red-50 text-red-600'
                    }`}
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          ))
        )}

        {/* D17 Info Card */}
        <div className={`rounded-xl p-4 border transition-colors ${
          darkMode ? 'bg-green-900/20 border-green-800' : 'bg-green-50 border-green-200'
        }`}>
          <div className="flex items-start space-x-3">
            <Smartphone className={`w-5 h-5 mt-0.5 ${
              darkMode ? 'text-green-400' : 'text-green-600'
            }`} />
            <div>
              <p className={`font-medium mb-1 ${
                darkMode ? 'text-green-400' : 'text-green-700'
              }`}>
                About D17
              </p>
              <p className={`text-sm ${
                darkMode ? 'text-green-300' : 'text-green-600'
              }`}>
                D17 is a secure mobile payment service available in Tunisia. Pay easily with your phone number.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Add Payment Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 flex items-end justify-center z-50">
          <div className={`w-full max-w-[390px] rounded-t-3xl p-6 transition-colors ${
            darkMode ? 'bg-gray-800' : 'bg-white'
          }`}>
            <h2 className={`text-xl font-semibold mb-4 ${
              darkMode ? 'text-white' : 'text-gray-900'
            }`}>
              {t('addPaymentMethod')}
            </h2>

            <div className="space-y-4">
              {/* Payment Type */}
              <div>
                <label className={`block text-sm font-medium mb-2 ${
                  darkMode ? 'text-gray-300' : 'text-gray-700'
                }`}>
                  Payment Type
                </label>
                <select
                  value={newMethod.type}
                  onChange={(e) => setNewMethod({ ...newMethod, type: e.target.value as any })}
                  className={`w-full px-4 py-3 rounded-lg border focus:outline-none focus:ring-2 focus:ring-[#0066FF] ${
                    darkMode 
                      ? 'bg-gray-700 border-gray-600 text-white' 
                      : 'bg-white border-gray-200 text-gray-900'
                  }`}
                >
                  <option value="d17">{t('d17MobileMoney')}</option>
                  <option value="card">{t('creditCard')}</option>
                  <option value="bank">{t('bankTransfer')}</option>
                </select>
              </div>

              {/* Details */}
              <div>
                <label className={`block text-sm font-medium mb-2 ${
                  darkMode ? 'text-gray-300' : 'text-gray-700'
                }`}>
                  {newMethod.type === 'd17' 
                    ? 'Phone Number'
                    : newMethod.type === 'card'
                    ? 'Card Number'
                    : 'IBAN'}
                </label>
                <input
                  type="text"
                  value={newMethod.details}
                  onChange={(e) => setNewMethod({ ...newMethod, details: e.target.value })}
                  placeholder={
                    newMethod.type === 'd17' ? '+216 XX XXX XXX' :
                    newMethod.type === 'card' ? 'XXXX XXXX XXXX XXXX' :
                    'TN XX XXXX XXXX XXXX XXXX XX'
                  }
                  className={`w-full px-4 py-3 rounded-lg border focus:outline-none focus:ring-2 focus:ring-[#0066FF] ${
                    darkMode 
                      ? 'bg-gray-700 border-gray-600 text-white placeholder-gray-500' 
                      : 'bg-white border-gray-200 text-gray-900 placeholder-gray-400'
                  }`}
                />
              </div>

              {/* Buttons */}
              <div className="flex space-x-3 pt-2">
                <button
                  onClick={() => setShowAddModal(false)}
                  className={`flex-1 py-3 rounded-lg font-semibold transition-colors ${
                    darkMode 
                      ? 'bg-gray-700 text-white hover:bg-gray-600' 
                      : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                  }`}
                >
                  {t('cancel')}
                </button>
                <button
                  onClick={handleAddPaymentMethod}
                  className="flex-1 py-3 rounded-lg font-semibold bg-[#0066FF] text-white hover:opacity-90 transition-opacity"
                >
                  {t('add')}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
