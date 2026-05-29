import { useState } from 'react';
import ProfileNav from '../../components/profile/ProfileNav';
import ProfileOverview from './ProfileOverview';
import Skills from './Skills';
import Experience from './Experience';
import Courses from './Courses';
import styles from './ProfileShell.module.scss';

const tabs = ['overview', 'skills', 'experience', 'courses'];

export default function ProfileShell({ onNavigate }) {
  const [activeTab, setActiveTab] = useState('overview');

  const renderContent = () => {
    switch (activeTab) {
      case 'overview':   return <ProfileOverview onNavigate={onNavigate} />;
      case 'skills':     return <Skills />;
      case 'experience': return <Experience />;
      case 'courses':    return <Courses />;
      default:           return <ProfileOverview onNavigate={onNavigate} />;
    }
  };

  return (
    <div className={styles.shell}>
      <ProfileNav active={activeTab} onChange={setActiveTab} />
      <main className={styles.content}>
        {renderContent()}
      </main>
    </div>
  );
}
