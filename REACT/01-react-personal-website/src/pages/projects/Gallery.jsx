import { skills } from '../../data/portfolio';
import styles from './Tech.module.scss';

export default function Tech() {
  return (
    <div className={styles.page}>
      <h2 className={styles.title}>Tech Stack</h2>
      <div className={styles.grid}>
        {skills.map(s => (
          <div key={s.name} className={styles.item} style={{ '--color': s.color }}>
            <span className={styles.icon}>{s.icon}</span>
            <span className={styles.name}>{s.name}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
