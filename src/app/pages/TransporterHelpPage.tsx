import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Search, ChevronDown, Phone, Mail, MessageCircle, TrendingUp, Shield, DollarSign } from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../contexts/LanguageContext';

export default function TransporterHelpPage() {
  const navigate = useNavigate();
  const { darkMode } = useTheme();
  const { t } = useLanguage();
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedFaq, setExpandedFaq] = useState<number | null>(null);

  const faqs = [
    {
      question: t('howToPostTrip') || 'Comment publier un trajet?',
      answer: t('howToPostTripAnswer') || 'Allez sur "Créer", remplissez les détails du trajet (origine, destination, date, capacité, prix), sélectionnez les types de colis acceptés, et publiez. Votre trajet sera visible pour tous les clients.'
    },
    {
      question: t('howMuchCommission') || 'Quelle est la commission sur mes revenus?',
      answer: t('howMuchCommissionAnswer') || 'Wassali prélève une commission de 10% sur chaque trajet complété. Vous recevez 90% du prix total payé par le client.'
    },
    {
      question: t('howToGetPaid') || 'Comment recevoir mes paiements?',
      answer: t('howToGetPaidAnswer') || 'Les paiements sont automatiquement transférés sur votre compte bancaire ou portefeuille mobile 48h après la livraison confirmée du colis.'
    },
    {
      question: t('canCancelTrip') || 'Puis-je annuler un trajet?',
      answer: t('canCancelTripAnswer') || 'Oui, vous pouvez annuler un trajet depuis votre tableau de bord. Si des réservations existent, les clients seront notifiés et remboursés automatiquement.'
    },
    {
      question: t('howInsuranceWorks') || 'Comment fonctionne l\'assurance?',
      answer: t('howInsuranceWorksAnswer') || 'Vous pouvez proposer une option d\'assurance (5-10% du prix). En cas de dommage ou perte, l\'assurance couvre jusqu\'à 500€. Wassali gère toutes les réclamations.'
    },
    {
      question: t('whatDocumentsNeeded') || 'Quels documents sont nécessaires?',
      answer: t('whatDocumentsNeededAnswer') || 'Vous devez fournir: carte d\'identité valide, permis de conduire, carte grise du véhicule, et justificatif de domicile. La vérification prend 24-48h.'
    },
    {
      question: t('howToIncreaseBookings') || 'Comment augmenter mes réservations?',
      answer: t('howToIncreaseBookingsAnswer') || 'Maintenez un bon rating (>4.5), proposez des prix compétitifs, publiez régulièrement des trajets, activez l\'assurance, et répondez rapidement aux messages.'
    },
    {
      question: t('whatIfClientNoShow') || 'Que faire si le client ne se présente pas?',
      answer: t('whatIfClientNoShowAnswer') || 'Attendez 15 minutes au point de rendez-vous. Si le client ne vient pas, signalez dans l\'app. Vous recevrez 50% du paiement comme compensation.'
    },
  ];

  const contactMethods = [
    {
      icon: Phone,
      title: t('phoneSupport') || 'Support téléphonique',
      value: '+216 XX XXX XXX',
      action: 'tel:+216XXXXXXXX',
      color: darkMode ? 'bg-green-900 text-green-300' : 'bg-green-100 text-green-600'
    },
    {
      icon: Mail,
      title: t('emailSupport') || 'Support email',
      value: 'transporter@wassali.tn',
      action: 'mailto:transporter@wassali.tn',
      color: darkMode ? 'bg-blue-900 text-blue-300' : 'bg-blue-100 text-blue-600'
    },
    {
      icon: MessageCircle,
      title: t('liveChat') || 'Chat en direct',
      value: t('available247') || 'Disponible 24/7',
      action: '/chat-support',
      color: darkMode ? 'bg-purple-900 text-purple-300' : 'bg-purple-100 text-purple-600'
    },
  ];

  const quickLinks = [
    {
      icon: TrendingUp,
      title: t('increaseEarnings') || 'Augmenter mes revenus',
      description: t('increaseEarningsDesc') || 'Conseils pour optimiser vos gains',
      path: '/earnings-tips',
      color: darkMode ? 'bg-orange-900 text-orange-300' : 'bg-orange-100 text-orange-600'
    },
    {
      icon: Shield,
      title: t('safetyGuidelines') || 'Consignes de sécurité',
      description: t('safetyGuidelinesDesc') || 'Protégez-vous et vos clients',
      path: '/safety-guide',
      color: darkMode ? 'bg-green-900 text-green-300' : 'bg-green-100 text-green-600'
    },
    {
      icon: DollarSign,
      title: t('paymentInfo') || 'Informations paiement',
      description: t('paymentInfoDesc') || 'Comment gérer vos revenus',
      path: '/payment-info',
      color: darkMode ? 'bg-blue-900 text-blue-300' : 'bg-blue-100 text-blue-600'
    },
  ];

  const filteredFaqs = faqs.filter(faq =>
    faq.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
    faq.answer.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className={`min-h-screen pb-20 ${darkMode ? 'bg-gray-900' : 'bg-gray-50'}`}>
      {/* Header */}
      <div className="bg-gradient-to-r from-[#FF9500] to-[#E68600] text-white p-6">
        <button 
          onClick={() => navigate('/transporter-profile')} 
          className="mb-4 p-2 hover:bg-white/10 rounded-full inline-flex"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="text-2xl font-semibold mb-2">{t('helpSupport') || 'Aide & Support'}</h1>
        <p className="text-orange-100 text-sm">{t('transporterHelpSubtitle') || 'Ressources pour transporteurs'}</p>
      </div>

      <div className="p-6 space-y-6">
        {/* Search */}
        <div className="relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder={t('searchHelp') || 'Rechercher dans l\'aide...'}
            className={`w-full pl-12 pr-4 py-3 rounded-xl border focus:outline-none focus:ring-2 focus:ring-[#FF9500] ${
              darkMode 
                ? 'bg-gray-800 border-gray-700 text-white' 
                : 'bg-white border-gray-200'
            }`}
          />
        </div>

        {/* Quick Links */}
        <div>
          <h2 className={`text-lg font-semibold mb-4 ${darkMode ? 'text-white' : 'text-gray-900'}`}>
            {t('quickLinks') || 'Liens rapides'}
          </h2>
          <div className="grid gap-3">
            {quickLinks.map((link, index) => (
              <button
                key={index}
                onClick={() => navigate(link.path)}
                className={`rounded-xl p-4 border transition-colors ${
                  darkMode 
                    ? 'bg-gray-800 border-gray-700 hover:border-[#FF9500]' 
                    : 'bg-white border-gray-200 hover:border-[#FF9500]'
                }`}
              >
                <div className="flex items-center space-x-4">
                  <div className={`w-12 h-12 ${link.color} rounded-full flex items-center justify-center`}>
                    <link.icon className="w-6 h-6" />
                  </div>
                  <div className="flex-1 text-left">
                    <p className={`font-medium ${darkMode ? 'text-white' : 'text-gray-900'}`}>
                      {link.title}
                    </p>
                    <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                      {link.description}
                    </p>
                  </div>
                  <ArrowLeft className={`w-5 h-5 rotate-180 ${darkMode ? 'text-gray-600' : 'text-gray-400'}`} />
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Contact Methods */}
        <div>
          <h2 className={`text-lg font-semibold mb-4 ${darkMode ? 'text-white' : 'text-gray-900'}`}>
            {t('contactUs') || 'Nous contacter'}
          </h2>
          <div className="grid gap-3">
            {contactMethods.map((method, index) => (
              <button
                key={index}
                onClick={() => {
                  if (method.action.startsWith('/')) {
                    navigate(method.action);
                  } else {
                    window.location.href = method.action;
                  }
                }}
                className={`rounded-xl p-4 border transition-colors ${
                  darkMode 
                    ? 'bg-gray-800 border-gray-700 hover:border-[#FF9500]' 
                    : 'bg-white border-gray-200 hover:border-[#FF9500]'
                }`}
              >
                <div className="flex items-center space-x-4">
                  <div className={`w-12 h-12 ${method.color} rounded-full flex items-center justify-center`}>
                    <method.icon className="w-6 h-6" />
                  </div>
                  <div className="flex-1 text-left">
                    <p className={`font-medium ${darkMode ? 'text-white' : 'text-gray-900'}`}>
                      {method.title}
                    </p>
                    <p className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                      {method.value}
                    </p>
                  </div>
                  <ArrowLeft className={`w-5 h-5 rotate-180 ${darkMode ? 'text-gray-600' : 'text-gray-400'}`} />
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* FAQs */}
        <div>
          <h2 className={`text-lg font-semibold mb-4 ${darkMode ? 'text-white' : 'text-gray-900'}`}>
            {t('faq') || 'Questions fréquentes'}
          </h2>
          <div className="space-y-3">
            {filteredFaqs.length > 0 ? (
              filteredFaqs.map((faq, index) => (
                <div
                  key={index}
                  className={`rounded-xl border overflow-hidden ${
                    darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'
                  }`}
                >
                  <button
                    onClick={() => setExpandedFaq(expandedFaq === index ? null : index)}
                    className={`w-full p-4 flex items-center justify-between text-left transition-colors ${
                      darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-50'
                    }`}
                  >
                    <span className={`font-medium pr-4 ${darkMode ? 'text-white' : 'text-gray-900'}`}>
                      {faq.question}
                    </span>
                    <ChevronDown
                      className={`w-5 h-5 transition-transform flex-shrink-0 ${
                        darkMode ? 'text-gray-400' : 'text-gray-400'
                      } ${expandedFaq === index ? 'rotate-180' : ''}`}
                    />
                  </button>
                  {expandedFaq === index && (
                    <div className={`px-4 pb-4 text-sm border-t pt-3 ${
                      darkMode 
                        ? 'text-gray-300 border-gray-700' 
                        : 'text-gray-600 border-gray-100'
                    }`}>
                      {faq.answer}
                    </div>
                  )}
                </div>
              ))
            ) : (
              <div className={`text-center py-8 ${darkMode ? 'text-gray-400' : 'text-gray-500'}`}>
                {t('noResultsFound') || 'Aucun résultat trouvé'}
              </div>
            )}
          </div>
        </div>
      </div>

      <BottomNav active="profile" />
    </div>
  );
}
