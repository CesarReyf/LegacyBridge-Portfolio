import styles from '../Core.module.scss';

export default function Header() {
  return (
    <header className={styles.header}>
      <span className={styles.logo}>&lt;/&gt; Portfolio</span>
    </header>
  );
}
