import styles from './Projects.module.scss';

const tabs = ['overview', 'tech', 'gallery'];
const labels = { overview: 'Overview', tech: 'Tech', gallery: 'Gallery' };
const icons = { overview: '📋', tech: '🛠️', gallery: '🖼️' };

export default function ProjectNav({ active, onChange, onBack }) {
  return (
    <aside className={styles.sidebar}>
      <button className={styles.backBtn} onClick={onBack}>
        ← Back
      </button>

      <nav className={styles.nav}>
        {tabs.map(tab => (
          <button
            key={tab}
            className={`${styles.navItem} ${active === tab ? styles.active : ''}`}
            onClick={() => onChange(tab)}
          >
            <span className={styles.icon}>{icons[tab]}</span>
            <span className={styles.label}>{labels[tab]}</span>
          </button>
        ))}
      </nav>
    </aside>
  );
}
