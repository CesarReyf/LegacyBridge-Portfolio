import { profile, skills, experience, projects } from '../../data/portfolio';
import Card from '../../components/ui/Card';
import Button from '../../components/ui/Button';
import GithubButton from '../../components/projects/GithubButton';
import styles from './ProfileOverview.module.scss';

const featuredProjects = projects.filter(p => p.featured);

export default function ProfileOverview({ onNavigate }) {
  return (
    <div className={styles.overview}>
      {/* Hero */}
      <section className={styles.hero}>
        <div className={styles.heroLeft}>
          <h1 className={styles.heroTitle}>
            Hi, I'm <span className={styles.accent}>{profile.name}</span>
          </h1>
          <p className={styles.heroRole}>{profile.role}</p>
          <Button onClick={() => onNavigate('projects')} variant="outline">
            View Projects →
          </Button>
        </div>
      </section>

      {/* 2x2 Grid: Bio | Skills / Experience | Featured Projects */}
      <div className={styles.grid}>
        {/* Bio Card */}
        <Card className={styles.bioCard}>
          <div className={styles.bioInner}>
            <div className={styles.avatarWrap}>
              {profile.avatar
                ? <img src={profile.avatar} alt={profile.name} className={styles.avatar} />
                : <div className={styles.avatarFallback}>{profile.name[0]}</div>
              }
            </div>
            <div>
              <p className={styles.tagline}>
                {profile.tagline}{' '}
                <span className={styles.accentBlue}>{profile.taglineHighlight}</span>
              </p>
              <p className={styles.bio}>{profile.bio}</p>
              <div className={styles.techBadges}>
                {skills.slice(0, 5).map(s => (
                  <span key={s.name} className={styles.badge}>{s.icon} {s.name}</span>
                ))}
              </div>
            </div>
          </div>
        </Card>

        {/* Skills Card */}
        <Card className={styles.skillsCard}>
          <div className={styles.panelHeader}>
            <h3>Skills</h3>
            <button className={styles.viewAll}>View all →</button>
          </div>
          <div className={styles.skillsList}>
            {skills.slice(0, 5).map(s => (
              <div key={s.name} className={styles.skillRow}>
                <div className={styles.skillInfo}>
                  <span>{s.icon}</span>
                  <span>{s.name}</span>
                </div>
                <span className={styles.skillPct}>{s.level}%</span>
                <div className={styles.skillBar}>
                  <div
                    className={styles.skillFill}
                    style={{ width: `${s.level}%`, background: s.color }}
                  />
                </div>
              </div>
            ))}
          </div>
        </Card>

        {/* Featured Projects Card */}
        <Card className={styles.projectsCard}>
          <div className={styles.panelHeader}>
            <h3>Featured Projects</h3>
            <button className={styles.viewAll} onClick={() => onNavigate('projects')}>
              View all →
            </button>
          </div>
          <div className={styles.projectsList}>
            {featuredProjects.slice(0, 2).map(p => (
              <div key={p.id} className={styles.projectItem}>
                <div className={styles.projectTop}>
                  <div className={styles.projectIcon} style={{ background: p.iconBg }}>
                    {p.icon}
                  </div>
                  {p.featured && <span className={styles.projectFeatured}>Featured</span>}
                </div>
                <h4 className={styles.projectName}>{p.name}</h4>
                <span className={styles.projectCat} style={{ color: p.categoryColor }}>
                  {p.category}
                </span>
                <p className={styles.projectDesc}>{p.description}</p>
                <div className={styles.projectTags}>
                  {p.tags.map(t => <span key={t} className={styles.projectTag}>{t}</span>)}
                </div>
                <div className={styles.projectLinks}>
                  <GithubButton href={p.github} />
                  {p.demo && (
                    <a
                      href={p.demo}
                      target="_blank"
                      rel="noopener noreferrer"
                      className={styles.demoLink}
                      title="View Demo"
                    >
                      🔗
                    </a>
                  )}
                </div>
              </div>
            ))}
          </div>
        </Card>

        {/* Experience Card */}
        <Card className={styles.expCard}>
          <div className={styles.panelHeader}>
            <h3>Experience</h3>
            <button className={styles.viewAll}>View all →</button>
          </div>
          <div className={styles.experienceList}>
            {experience.map((e, i) => (
              <div key={i} className={styles.expRow}>
                <div className={styles.expDot} />
                <div>
                  <div className={styles.expTitle}>
                    <span>{e.title}</span>
                    <span className={styles.expPeriod}>{e.period}</span>
                  </div>
                  <p className={styles.expCompany}>{e.company}</p>
                  <p className={styles.expDesc}>{e.description}</p>
                </div>
              </div>
            ))}
          </div>
        </Card>

      </div>
    </div>
  );
}
