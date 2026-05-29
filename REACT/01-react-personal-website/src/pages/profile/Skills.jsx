import { skills } from '../../data/portfolio';
import Card from '../../components/ui/Card';
import styles from './Skills.module.scss';

export default function Skills() {
  return (
    <div className={styles.page}>
      <h2 className={styles.title}>Skills</h2>
      <div className={styles.grid}>
        {skills.map(s => (
          <Card key={s.name} className={styles.card}>
            <div className={styles.header}>
              <span className={styles.icon}>{s.icon}</span>
              <span className={styles.name}>{s.name}</span>
              <span className={styles.pct}>{s.level}%</span>
            </div>
            <div className={styles.barBg}>
              <div className={styles.barFill} style={{ width: `${s.level}%`, background: s.color }} />
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
