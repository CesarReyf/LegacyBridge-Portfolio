import { projects } from '../../data/portfolio';
import Card from '../../components/ui/Card';
import GithubButton from '../../components/projects/GithubButton';
import styles from './ProjectOverview.module.scss';

export default function ProjectOverview() {
  return (
    <div className={styles.page}>
      <h2 className={styles.title}>All Projects</h2>
      <div className={styles.grid}>
        {projects.map(p => (
          <Card key={p.id} className={styles.card}>
            <div className={styles.top}>
              <div className={styles.icon} style={{ background: p.iconBg }}>{p.icon}</div>
              {p.featured && <span className={styles.featured}>Featured</span>}
            </div>
            <h3 className={styles.name}>{p.name}</h3>
            <span className={styles.cat} style={{ color: p.categoryColor }}>{p.category}</span>
            <p className={styles.desc}>{p.description}</p>
            <div className={styles.tags}>
              {p.tags.map(t => <span key={t} className={styles.tag}>{t}</span>)}
            </div>
            <div className={styles.links}>
              <GithubButton href={p.github} />
              {p.demo && (
                <a href={p.demo} target="_blank" rel="noopener noreferrer" className={styles.demoLink}>
                  🔗 Demo
                </a>
              )}
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
