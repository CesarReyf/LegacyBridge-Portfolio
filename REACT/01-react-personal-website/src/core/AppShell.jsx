import { useState } from 'react';
import BottomNav from './navigation/BottomNav';
import Routes from './Routes';
import styles from './Core.module.scss';

export default function AppShell() {
  const [activeSection, setActiveSection] = useState('profile');

  return (
    <div className={styles.shell}>
      <main className={styles.main}>
        <Routes
          activeSection={activeSection}
          setActiveSection={setActiveSection}
        />
      </main>
      <BottomNav active={activeSection} onChange={setActiveSection} />
    </div>
  );
}
