import { experience } from '../../data/portfolio';
import Card from '../../components/ui/Card';
import styles from './Experience.module.scss';

export default function Experience() {
  return (
    <div className={styles.page}>
      <h2 className={styles.title}>Experience</h2>
      <div className={styles.timeline}>
        {experience.map((e, i) => (
          <Card key={i} className={styles.card}>
            <div className={styles.dot} />
            <div className={styles.body}>
              <div className={styles.header}>
                <h3 className={styles.jobTitle}>{e.title}</h3>
                <span className={styles.period}>{e.period}</span>
              </div>
              <p className={styles.company}>{e.company}</p>
              <p className={styles.desc}>{e.description}</p>
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
