import { courses } from '../../data/portfolio';
import Card from '../../components/ui/Card';
import styles from './Courses.module.scss';

export default function Courses() {
  return (
    <div className={styles.page}>
      <h2 className={styles.title}>Courses & Certifications</h2>
      <div className={styles.grid}>
        {courses.map((c, i) => (
          <Card key={i} className={styles.card}>
            <span className={styles.badge}>{c.badge}</span>
            <div>
              <h4 className={styles.name}>{c.name}</h4>
              <p className={styles.meta}>{c.platform} · {c.year}</p>
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
