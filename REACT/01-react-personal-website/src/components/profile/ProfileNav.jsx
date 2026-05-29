import styles from './Profile.module.scss';

const tabs = ['overview', 'skills', 'experience', 'courses'];
const labels = { overview: 'Overview', skills: 'Skills', experience: 'Experience', courses: 'Courses' };
const icons = { overview: '👤', skills: '⭐', experience: '💼', courses: '🎓' };

export default function ProfileNav({ active, onChange }) {
  return (
    <aside className={styles.sidebar}>
      <div className={styles.header}>
        <div className={styles.logo}>&lt;/&gt;</div>
        <div className={styles.brandName}>Cekror</div>
        <div className={styles.role}>Backend Engineer</div>
      </div>

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
