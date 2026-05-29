import styles from './Projects.module.scss';

export default function GithubButton({ href, label = "View on GitHub" }) {
  if (!href) return null;
  
  return (
    <a 
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className={styles.button}
    >
      🐙 {label}
    </a>
  );
}
