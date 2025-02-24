Return-Path: <linux-bcache+bounces-847-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31AEEA4199B
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Feb 2025 10:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D43C73AC4FB
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Feb 2025 09:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832402451F1;
	Mon, 24 Feb 2025 09:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0usiYCP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B0423F439;
	Mon, 24 Feb 2025 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740390830; cv=none; b=FKo9mgqjY5DPjz/gh96jJuiBMyjiece+/hyoKr3LQZv69WTM64kqLLXsrATFFPGXFTA0tpmBof6z7dHfiaiS1DuZEzlh5++Y0W69UgzHcpukkZ9peNTFEN7giUq6kKlSg3e7AtrGkmQi9x7cfQTdPe2aVe0ni/2nPJhPFmjlIBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740390830; c=relaxed/simple;
	bh=g6VMlunQlRDJng03dDx4fAmN66ot/J1KNDpnUBk3Uyk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ulWgXpaoEulCWbVBF5Kty8v9E4VqgC7qZ4FSKPfInZenQ9negH3nbeiP1lXQq/1zmdIcBpvrPW8JTieXVHqbZbyElyOI9q1ZHTkFtcEr/8H5qE1jwNEZxE4B3eIdfRrIgFy/RqxlrfrJDCPOnI+VNwzXOJgikTcgeDhL4iq2pHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0usiYCP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349C1C4CED6;
	Mon, 24 Feb 2025 09:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740390829;
	bh=g6VMlunQlRDJng03dDx4fAmN66ot/J1KNDpnUBk3Uyk=;
	h=Date:From:To:Cc:Subject:From;
	b=u0usiYCPpGjJz7W/r+tTDedwSQMO7Lzj2OGrQ7vpI1I6Ni/J58p4fjs01N0vVrCAy
	 CupqoMmeyJpmyBT33Swem7HP4O4OA6qZfthw2HnsZgFr0H9T56aiYr5z8HSIvhJ3wo
	 ILS61Ps7NSn2v37GJTsxM5FAS2tS1WmZhYCJYPxRjxaqBATn6A3KKZsis22HoJbvBC
	 y5bUAgcJHr9xYjQfadxhzbrj9AfhEsQrt1QeJxY+PA7PsZYrl0y2GkNEOsO7eMJumX
	 eTDcPsCHnH8iIhJ75t4YE7EeEjvUZNPoyVSCrYXZ1Xo9lYedRKjQFhXI8schHBm7m7
	 B5W68rNG+/KDA==
Date: Mon, 24 Feb 2025 20:23:38 +1030
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-btrfs@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-bcache@vger.kernel.org
Subject: [PATCH 0/8][next] Avoid a couple hundred
 -Wflex-array-member-not-at-end warnings
Message-ID: <cover.1739957534.git.gustavoars@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch series aims to fix a couple hundred -Wflex-array-member-not-at-end
warnings by creating a new tagged struct `struct bio_hdr` within flexible
structure `struct bio`.

This new tagged struct will be used to fix problematic declarations
of middle-flex-arrays in composite structs, like these[1][2][3], for
instance.

[1] https://git.kernel.org/linus/a7e8997ae18c42d3
[2] https://git.kernel.org/linus/c1ddb29709e675ea
[3] https://git.kernel.org/linus/57be3d3562ca4aa6

Gustavo A. R. Silva (8):
  block: blk_types.h: Use struct_group_tagged() in flex struct bio
  md/raid5-ppl: Avoid -Wflex-array-member-not-at-end warning
  xfs: Avoid -Wflex-array-member-not-at-end warnings
  erofs: Avoid -Wflex-array-member-not-at-end warnings
  btrfs: Avoid -Wflex-array-member-not-at-end warnings
  nvme: target: Avoid -Wflex-array-member-not-at-end warnings
  md/raid5: Avoid -Wflex-array-member-not-at-end warnings
  bcache: Avoid -Wflex-array-member-not-at-end warnings

 drivers/md/bcache/bcache.h     |  4 +-
 drivers/md/bcache/journal.c    | 10 ++--
 drivers/md/bcache/journal.h    |  4 +-
 drivers/md/bcache/super.c      |  8 ++--
 drivers/md/raid5-ppl.c         |  8 ++--
 drivers/md/raid5.c             | 10 ++--
 drivers/md/raid5.h             |  2 +-
 drivers/nvme/target/nvmet.h    |  4 +-
 drivers/nvme/target/passthru.c |  2 +-
 drivers/nvme/target/zns.c      |  2 +-
 fs/btrfs/disk-io.c             |  4 +-
 fs/btrfs/volumes.h             |  2 +-
 fs/erofs/fileio.c              | 25 ++++++----
 fs/erofs/fscache.c             | 13 +++---
 fs/xfs/xfs_log.c               | 15 +++---
 fs/xfs/xfs_log_priv.h          |  2 +-
 include/linux/blk_types.h      | 84 ++++++++++++++++++----------------
 17 files changed, 107 insertions(+), 92 deletions(-)

-- 
2.43.0


