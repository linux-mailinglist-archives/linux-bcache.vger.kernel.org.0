Return-Path: <linux-bcache+bounces-252-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0099D83EDDB
	for <lists+linux-bcache@lfdr.de>; Sat, 27 Jan 2024 16:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B2BB1C21331
	for <lists+linux-bcache@lfdr.de>; Sat, 27 Jan 2024 15:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E899628DD3;
	Sat, 27 Jan 2024 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WGKPTwHv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D251EA76
	for <linux-bcache@vger.kernel.org>; Sat, 27 Jan 2024 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706368854; cv=none; b=Z39ObDOoyNNRMskJaP74dxqq7gF16742utNKQdmR7PgS1fZKeaGBeC3FN2M5cyZ39CQZYi2buHmrJRtiekodFNT1yLIoVLqRFbA/+/evdkf8UPnimvsKl65nk8cH3bmEDJVc2BlZ7oSa0Gemgq1FLew8uRGKOnQTUp5cz36gDSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706368854; c=relaxed/simple;
	bh=wilSicJhWwERnmVX9GceQmQr35AE1fiUYJoUpMTUsHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4qGSoD9WZmYg0QD9qaogbHr6e2QsYcSNY8VQyAVTTUFNtx2jZJMrmCJ6M8KUCnkA3eftvZLWrBSc5q9quHf1/E/k6/HOp4DmmF0swbzRFhAifsCyygEtUQMG7IaPbgXrocwPtZ1zzvuPUXZtX9JH7zrWCvBg0jtjcrdY121JBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WGKPTwHv; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 27 Jan 2024 10:20:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706368851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=02z/TrmtiGbUOiCDc1VZWJkHRhcxM9+ZNLI+hwzY088=;
	b=WGKPTwHvBpWp2pyFXXTRUnKV8+jhjqe2vf5mHhl8eFkJBnAVn/HYBzEg1o//BjUllTcCF3
	1qKfLwP1Mu6nWeQkhRO/dRbuZ07hKPXOEApu2ADhXxOYNefP/2HSnH0johtQ2lkDwlhb7e
	54aSs6UAawKU1I54wnGkJWZrWrMN0I4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Joshua Ashton <joshua@froggi.es>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/5] bcachefs: bch2_time_stats_to_seq_buf()
Message-ID: <5efhxgruvtlrjiqe52kgmnduguw3tmg2jjugfzi7dhbywljrwi@zu2ndkvzunzs>
References: <20240126220655.395093-1-kent.overstreet@linux.dev>
 <20240126220655.395093-3-kent.overstreet@linux.dev>
 <DA69BC9C-D7FF-48F7-9F6D-EF96DC4C5C7B@froggi.es>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DA69BC9C-D7FF-48F7-9F6D-EF96DC4C5C7B@froggi.es>
X-Migadu-Flow: FLOW_OUT

On Sat, Jan 27, 2024 at 03:49:29AM +0000, Joshua Ashton wrote:
> Kernel patches need descriptions.

I think this one was pretty clear from the name and type signature :)

> 
> On January 26, 2024 10:06:53 PM GMT, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> >---
> > fs/bcachefs/super.c |   2 +
> > fs/bcachefs/util.c  | 129 +++++++++++++++++++++++++++++++++++++++-----
> > fs/bcachefs/util.h  |   4 ++
> > 3 files changed, 121 insertions(+), 14 deletions(-)
> >
> >diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> >index da8697c79a97..e74534096cb5 100644
> >--- a/fs/bcachefs/super.c
> >+++ b/fs/bcachefs/super.c
> >@@ -1262,6 +1262,8 @@ static struct bch_dev *__bch2_dev_alloc(struct bch_fs *c,
> > 
> > 	bch2_time_stats_init(&ca->io_latency[READ]);
> > 	bch2_time_stats_init(&ca->io_latency[WRITE]);
> >+	ca->io_latency[READ].quantiles_enabled = true;
> >+	ca->io_latency[WRITE].quantiles_enabled = true;
> > 
> > 	ca->mi = bch2_mi_to_cpu(member);
> > 
> >diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> >index c7cf9c6fcf9a..f2c8550c1331 100644
> >--- a/fs/bcachefs/util.c
> >+++ b/fs/bcachefs/util.c
> >@@ -505,10 +505,8 @@ static inline void pr_name_and_units(struct printbuf *out, const char *name, u64
> > 
> > void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats)
> > {
> >-	const struct time_unit *u;
> > 	s64 f_mean = 0, d_mean = 0;
> >-	u64 q, last_q = 0, f_stddev = 0, d_stddev = 0;
> >-	int i;
> >+	u64 f_stddev = 0, d_stddev = 0;
> > 
> > 	if (stats->buffer) {
> > 		int cpu;
> >@@ -607,19 +605,122 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
> > 
> > 	printbuf_tabstops_reset(out);
> > 
> >-	i = eytzinger0_first(NR_QUANTILES);
> >-	u = pick_time_units(stats->quantiles.entries[i].m);
> >+	if (stats->quantiles_enabled) {
> >+		int i = eytzinger0_first(NR_QUANTILES);
> >+		const struct time_unit *u =
> >+			pick_time_units(stats->quantiles.entries[i].m);
> >+		u64 last_q = 0;
> >+
> >+		prt_printf(out, "quantiles (%s):\t", u->name);
> >+		eytzinger0_for_each(i, NR_QUANTILES) {
> >+			bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
> >+
> >+			u64 q = max(stats->quantiles.entries[i].m, last_q);
> >+			prt_printf(out, "%llu ", div_u64(q, u->nsecs));
> >+			if (is_last)
> >+				prt_newline(out);
> >+			last_q = q;
> >+		}
> >+	}
> >+}
> >+
> >+#include <linux/seq_buf.h>
> >+
> >+static void seq_buf_time_units_aligned(struct seq_buf *out, u64 ns)
> >+{
> >+	const struct time_unit *u = pick_time_units(ns);
> >+
> >+	seq_buf_printf(out, "%8llu %s", div64_u64(ns, u->nsecs), u->name);
> >+}
> >+
> >+void bch2_time_stats_to_seq_buf(struct seq_buf *out, struct bch2_time_stats *stats)
> >+{
> >+	s64 f_mean = 0, d_mean = 0;
> >+	u64 f_stddev = 0, d_stddev = 0;
> >+
> >+	if (stats->buffer) {
> >+		int cpu;
> > 
> >-	prt_printf(out, "quantiles (%s):\t", u->name);
> >-	eytzinger0_for_each(i, NR_QUANTILES) {
> >-		bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
> >+		spin_lock_irq(&stats->lock);
> >+		for_each_possible_cpu(cpu)
> >+			__bch2_time_stats_clear_buffer(stats, per_cpu_ptr(stats->buffer, cpu));
> >+		spin_unlock_irq(&stats->lock);
> >+	}
> > 
> >-		q = max(stats->quantiles.entries[i].m, last_q);
> >-		prt_printf(out, "%llu ",
> >-		       div_u64(q, u->nsecs));
> >-		if (is_last)
> >-			prt_newline(out);
> >-		last_q = q;
> >+	/*
> >+	 * avoid divide by zero
> >+	 */
> >+	if (stats->freq_stats.n) {
> >+		f_mean = mean_and_variance_get_mean(stats->freq_stats);
> >+		f_stddev = mean_and_variance_get_stddev(stats->freq_stats);
> >+		d_mean = mean_and_variance_get_mean(stats->duration_stats);
> >+		d_stddev = mean_and_variance_get_stddev(stats->duration_stats);
> >+	}
> >+
> >+	seq_buf_printf(out, "count: %llu\n", stats->duration_stats.n);
> >+
> >+	seq_buf_printf(out, "                       since mount        recent\n");
> >+
> >+	seq_buf_printf(out, "duration of events\n");
> >+
> >+	seq_buf_printf(out, "  min:                     ");
> >+	seq_buf_time_units_aligned(out, stats->min_duration);
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "  max:                     ");
> >+	seq_buf_time_units_aligned(out, stats->max_duration);
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "  total:                   ");
> >+	seq_buf_time_units_aligned(out, stats->total_duration);
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "  mean:                    ");
> >+	seq_buf_time_units_aligned(out, d_mean);
> >+	seq_buf_time_units_aligned(out, mean_and_variance_weighted_get_mean(stats->duration_stats_weighted));
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "  stddev:                  ");
> >+	seq_buf_time_units_aligned(out, d_stddev);
> >+	seq_buf_time_units_aligned(out, mean_and_variance_weighted_get_stddev(stats->duration_stats_weighted));
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "time between events\n");
> >+
> >+	seq_buf_printf(out, "  min:                     ");
> >+	seq_buf_time_units_aligned(out, stats->min_freq);
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "  max:                     ");
> >+	seq_buf_time_units_aligned(out, stats->max_freq);
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "  mean:                    ");
> >+	seq_buf_time_units_aligned(out, f_mean);
> >+	seq_buf_time_units_aligned(out, mean_and_variance_weighted_get_mean(stats->freq_stats_weighted));
> >+	seq_buf_printf(out, "\n");
> >+
> >+	seq_buf_printf(out, "  stddev:                  ");
> >+	seq_buf_time_units_aligned(out, f_stddev);
> >+	seq_buf_time_units_aligned(out, mean_and_variance_weighted_get_stddev(stats->freq_stats_weighted));
> >+	seq_buf_printf(out, "\n");
> >+
> >+	if (stats->quantiles_enabled) {
> >+		int i = eytzinger0_first(NR_QUANTILES);
> >+		const struct time_unit *u =
> >+			pick_time_units(stats->quantiles.entries[i].m);
> >+		u64 last_q = 0;
> >+
> >+		prt_printf(out, "quantiles (%s):\t", u->name);
> >+		eytzinger0_for_each(i, NR_QUANTILES) {
> >+			bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
> >+
> >+			u64 q = max(stats->quantiles.entries[i].m, last_q);
> >+			seq_buf_printf(out, "%llu ", div_u64(q, u->nsecs));
> >+			if (is_last)
> >+				seq_buf_printf(out, "\n");
> >+			last_q = q;
> >+		}
> > 	}
> > }
> > #else
> >diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
> >index c3b11c3d24ea..7ff2d4fe26f6 100644
> >--- a/fs/bcachefs/util.h
> >+++ b/fs/bcachefs/util.h
> >@@ -382,6 +382,7 @@ struct bch2_time_stat_buffer {
> > 
> > struct bch2_time_stats {
> > 	spinlock_t	lock;
> >+	bool		quantiles_enabled;
> > 	/* all fields are in nanoseconds */
> > 	u64             min_duration;
> > 	u64		max_duration;
> >@@ -435,6 +436,9 @@ static inline bool track_event_change(struct bch2_time_stats *stats,
> > 
> > void bch2_time_stats_to_text(struct printbuf *, struct bch2_time_stats *);
> > 
> >+struct seq_buf;
> >+void bch2_time_stats_to_seq_buf(struct seq_buf *, struct bch2_time_stats *);
> >+
> > void bch2_time_stats_exit(struct bch2_time_stats *);
> > void bch2_time_stats_init(struct bch2_time_stats *);
> > 
> >-- 
> >2.43.0
> >
> >
> 
> - Joshie 🐸✨

