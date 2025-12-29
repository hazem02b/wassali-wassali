import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Search, ChevronDown, Phone, Mail, MessageCircle, FileText } from 'lucide-react';
import BottomNav from '../components/BottomNav';

export default function HelpSupportPage() {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedFaq, setExpandedFaq] = useState<number | null>(null);

  const faqs = [
    {
      question: 'How do I book a parcel delivery?',
      answer: 'Search for available trips, select your preferred transporter, fill in package details, and complete the payment. You\'ll receive a confirmation with tracking details.'
    },
    {
      question: 'What payment methods are accepted?',
      answer: 'We accept mobile wallets (D17, Ooredoo Money), credit/debit cards, bank transfers, and cash on pickup.'
    },
    {
      question: 'How can I track my package?',
      answer: 'Go to "My Bookings" in the app, select your booking, and view real-time tracking information and status updates.'
    },
    {
      question: 'What if my package is damaged?',
      answer: 'Report the issue immediately through the app. Our support team will investigate and process compensation according to our insurance policy.'
    },
    {
      question: 'Can I cancel my booking?',
      answer: 'Yes, you can cancel up to 24 hours before departure. Cancellation fees may apply depending on the timing.'
    },
    {
      question: 'How do I become a transporter?',
      answer: 'Sign up as a transporter, complete verification (ID, vehicle documents), and start posting your trips. Commission rates apply.'
    },
  ];

  const contactMethods = [
    {
      icon: Phone,
      title: 'Phone Support',
      value: '+216 XX XXX XXX',
      action: 'tel:+216XXXXXXXX',
      color: 'bg-green-100 text-green-600'
    },
    {
      icon: Mail,
      title: 'Email Support',
      value: 'support@wassali.tn',
      action: 'mailto:support@wassali.tn',
      color: 'bg-blue-100 text-blue-600'
    },
    {
      icon: MessageCircle,
      title: 'Live Chat',
      value: 'Available 24/7',
      action: '/chat-support',
      color: 'bg-purple-100 text-purple-600'
    },
  ];

  const filteredFaqs = faqs.filter(faq =>
    faq.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
    faq.answer.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Header */}
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6">
        <button onClick={() => navigate(-1)} className="mb-4 p-2 hover:bg-white/10 rounded-full inline-flex">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="text-2xl font-semibold mb-2">Help & Support</h1>
        <p className="text-blue-100 text-sm">We're here to help you 24/7</p>
      </div>

      <div className="p-6 space-y-6">
        {/* Search */}
        <div className="relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search for help..."
            className="w-full pl-12 pr-4 py-3 bg-white rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-[#0066FF]"
          />
        </div>

        {/* Contact Methods */}
        <div>
          <h2 className="text-lg font-semibold mb-4">Contact Us</h2>
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
                className="bg-white rounded-xl p-4 border border-gray-200 hover:border-[#0066FF] transition-colors"
              >
                <div className="flex items-center space-x-4">
                  <div className={`w-12 h-12 ${method.color} rounded-full flex items-center justify-center`}>
                    <method.icon className="w-6 h-6" />
                  </div>
                  <div className="flex-1 text-left">
                    <p className="font-medium">{method.title}</p>
                    <p className="text-sm text-gray-600">{method.value}</p>
                  </div>
                  <ArrowLeft className="w-5 h-5 text-gray-400 rotate-180" />
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* FAQs */}
        <div>
          <h2 className="text-lg font-semibold mb-4">Frequently Asked Questions</h2>
          <div className="space-y-3">
            {filteredFaqs.length > 0 ? (
              filteredFaqs.map((faq, index) => (
                <div
                  key={index}
                  className="bg-white rounded-xl border border-gray-200 overflow-hidden"
                >
                  <button
                    onClick={() => setExpandedFaq(expandedFaq === index ? null : index)}
                    className="w-full p-4 flex items-center justify-between text-left hover:bg-gray-50 transition-colors"
                  >
                    <span className="font-medium pr-4">{faq.question}</span>
                    <ChevronDown
                      className={`w-5 h-5 text-gray-400 transition-transform flex-shrink-0 ${
                        expandedFaq === index ? 'rotate-180' : ''
                      }`}
                    />
                  </button>
                  {expandedFaq === index && (
                    <div className="px-4 pb-4 text-sm text-gray-600 border-t border-gray-100 pt-3">
                      {faq.answer}
                    </div>
                  )}
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-500">
                <p>No results found for "{searchQuery}"</p>
              </div>
            )}
          </div>
        </div>

        {/* Documentation */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center space-x-3 mb-3">
            <FileText className="w-5 h-5 text-[#0066FF]" />
            <h3 className="font-semibold">Documentation</h3>
          </div>
          <div className="space-y-2 text-sm">
            <button
              onClick={() => navigate('/terms')}
              className="w-full text-left p-2 hover:bg-gray-50 rounded-lg text-gray-700"
            >
              Terms & Conditions
            </button>
            <button
              onClick={() => navigate('/privacy')}
              className="w-full text-left p-2 hover:bg-gray-50 rounded-lg text-gray-700"
            >
              Privacy Policy
            </button>
            <button
              onClick={() => navigate('/user-guide')}
              className="w-full text-left p-2 hover:bg-gray-50 rounded-lg text-gray-700"
            >
              User Guide
            </button>
          </div>
        </div>
      </div>

      <BottomNav active="profile" />
    </div>
  );
}
