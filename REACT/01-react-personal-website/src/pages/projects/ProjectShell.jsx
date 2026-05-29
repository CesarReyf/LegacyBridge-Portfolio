import { useState } from 'react';
import ProjectNav from '../../components/projects/ProjectNav';
import ProjectOverview from './ProjectOverview';
import Tech from './Tech';
import Gallery from './Gallery';
import styles from './ProjectShell.module.scss';

export default function ProjectShell({ onNavigate }) {
  const [activeTab, setActiveTab] = useState('overview');

  const renderContent = () => {
    switch (activeTab) {
      case 'overview': return <ProjectOverview />;
      case 'tech':     return <Tech />;
      case 'gallery':  return <Gallery />;
      default:         return <ProjectOverview />;
    }
  };

  return (
    <div className={styles.shell}>
      <ProjectNav active={activeTab} onChange={setActiveTab} onBack={() => onNavigate('profile')} />
      <main className={styles.content}>
        {renderContent()}
      </main>
    </div>
  );
}
