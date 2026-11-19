"""Tests for crawlers."""

import pytest

from collate_sqlfluff.core.config import FluffConfig
from collate_sqlfluff.core.linter.linter import Linter
from collate_sqlfluff.core.rules.context import RuleContext
from collate_sqlfluff.core.rules.crawlers import (
    ParentOfSegmentCrawler,
    RootOnlyCrawler,
    SegmentSeekerCrawler,
)
from collate_sqlfluff.core.templaters.base import TemplatedFile


@pytest.mark.parametrize(
    "CrawlerType,crawler_kwargs,raw_sql_in,target_raws_out",
    [
        (RootOnlyCrawler, {}, "SELECT 1 + 2", ["SELECT 1 + 2"]),
        (
            SegmentSeekerCrawler,
            {"types": {"numeric_literal"}},
            "SELECT 1 + 2",
            ["1", "2"],
        ),
        (
            ParentOfSegmentCrawler,
            {"types": {"numeric_literal"}},
            "SELECT 1 + 2",
            ["1 + 2"],
        ),
    ],
)
def test_rules_crawlers(CrawlerType, crawler_kwargs, raw_sql_in, target_raws_out):
    """Test Crawlers."""
    cfg = FluffConfig(overrides={"dialect": "ansi"})
    linter = Linter(config=cfg)
    root = linter.parse_string(raw_sql_in).tree

    root_context = RuleContext(
        dialect=cfg.get("dialect_obj"),
        fix=True,
        templated_file=TemplatedFile(raw_sql_in, "<test-case>"),
        path=None,
        segment=root,
        config=cfg,
    )

    crawler = CrawlerType(**crawler_kwargs)

    result_raws = [context.segment.raw for context in crawler.crawl(root_context)]

    assert result_raws == target_raws_out
