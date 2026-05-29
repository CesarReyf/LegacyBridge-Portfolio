import styles from '../Core.module.scss';

const items = [
  { id: 'profile',  label: 'Profile',   icon: '👤' },
  { id: 'projects', label: 'Projects',  icon: '</>' },
  { id: 'github',   label: 'GitHub',    icon: '🐙', href: 'https://github.com/cekror' },
  { id: 'contact',  label: 'Contact',   icon: '✉️',  href: 'mailto:cekror@email.com' },
];

export default function BottomNav({ active, onChange }) {
  return (
    <nav className={styles.nav}>
      {items.map(item => {
        if (item.href) {
          return (
            <a key={item.id} href={item.href} target="_blank" rel="noopener noreferrer" className={styles.item}>
              <span className={styles.icon}>{item.icon}</span>
              <span className={styles.label}>{item.label}</span>
            </a>
          );
        }
        return (
          <button
            key={item.id}
            className={`${styles.item} ${active === item.id ? styles.active : ''}`}
            onClick={() => onChange(item.id)}
          >
            <span className={styles.icon}>{item.icon}</span>
            <span className={styles.label}>{item.label}</span>
          </button>
        );
      })}
    </nav>
  );
}
