Return-Path: <linux-bcache+bounces-745-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6466F99BADF
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 20:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01E0C2816C3
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 18:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AD51494A7;
	Sun, 13 Oct 2024 18:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIm2cNnN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF5F811E2;
	Sun, 13 Oct 2024 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845249; cv=none; b=LSyDINtw/sTedizWqTtwPvY6A62yMfB++EIJFie7mhKVlgj0QNVi13NfKuePMJpyVOOzTXG/nh4L5Sup+4gTU6bE5zVqachxlejpKqaBp1x9RYZBuAb96L3TLorTCX7acswZ2Z5pDUMwv9QZ0FIyabM8IoiBeIaYDiVY8R6XV7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845249; c=relaxed/simple;
	bh=Kb7aX7slRhx0WODloa6fxT3r3WjHydojQpLCssKONZg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gftd6e4GWlElHjajg68MmDWtfOB0EnUo898DMVl/Cf1H5gYssQZjEQJ0tYq2VvdL+0PNFZPC+CWxEHm1T4LkzquS9E76hGXnWIwUsVmGNky1O5drrl6iCCvRpdmEsnMFu9OObItmn66nQ14N2zrTIu2RMS2tDLzKjeEuqTE0vVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIm2cNnN; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20c77459558so27458705ad.0;
        Sun, 13 Oct 2024 11:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845246; x=1729450046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AcT+988WrW3AMkjQ8YktZMykd7mkHA4KLE0Ju/bOgnY=;
        b=CIm2cNnNXddGZlcoXclWlCIM1vyeAT3aNgCyMZ7LAcb3mS+rFoYIoPwejJVoqM9tRB
         DRjd274QyX9WRdXB6vOFLtC3l7zhzjcwjSNnd41+3OrNBPvpbwDDkv2ZD4vY0I+rodCI
         FO9l0WRIYjzXR0o+FSKEHjG2ElFhCfVC6dSfsesiIcQi4CvN/lgFGZTTTd/6kW9kbhJX
         o3VNENiADngGCtXxCWRKP1QxLZ5URjr9oBYEtNEpF3jfvD2iFSGv61+zLFBajHforS45
         DnnsewKzJgn1ZzjrkFqObb7G622vcXhSXJ/a8Pbb4qOmaMowvXZ96pI+r+pueqvtJi7d
         FKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845246; x=1729450046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AcT+988WrW3AMkjQ8YktZMykd7mkHA4KLE0Ju/bOgnY=;
        b=pglezg0pPH+kzDcCzR0UC/AxNZ2XZtm7+RUnc3sHEJzm+eh1qKSY6pr1xxnP3bLGd8
         IZpe8N2J/f/ggoJgxu4JezG47AbbFUsLFDTBb+Mv0/v/wdwLzGEp//5A8qtWLNMGU4w+
         HTqQEFimM6w1DC/8Wf7xRRsbQL0MBKCWyWXJ032fhKdpE6l5leL5MWoImRY6i4I0PwR2
         5satvnknO1LjSfROVAkkjSS+2k8Yk336ADX6rTsOnyMrOJ+1d30QdDfUtgWVkTWCpSjs
         TxxvXZYNO8aRZ8MPFz4Gp5TpKq+6X/5FBcHU5RfUllm+32YIOq0rqYenchG0WaXrWLiK
         cZzA==
X-Forwarded-Encrypted: i=1; AJvYcCV/rZvW1K+fYQ7fOC56FVMiB7KmaLN30OhtyziMLE8UL3cr6ut0KDECfOnDMSXQU6ZZAslVjuHgS1Ww@vger.kernel.org, AJvYcCV41PF7jlek5o35vsCAqJ3qXSCZIow/zrq4C205U3/3grdQOy6KYLTJqa4tfuDzCO2nL1HGatK1jKIvoRfHBCo=@vger.kernel.org, AJvYcCVNACbcoRSsDjh2u08OrtRd80UiNe4DumZMeIJ1wqi6TljH1r5ALKrps+WM3SEuPteNIIXjuRf/iMMMsB3k9J/6ww==@vger.kernel.org, AJvYcCW8dAUyYA9jmi2uEy9hZBwq8w0iNyzVq6vABkPMCIOG0hWdiaAF5r4+QuyU2fNe0SH/zqxgThdA6pUbBpA=@vger.kernel.org, AJvYcCWsopT6BEQxiT2idrv9mcC5khkXnBTpARWfLYPkhCW+xhqnQMcIbMb1feqM8qrWmgM9OmHauMpXFPpt7Ko8@vger.kernel.org
X-Gm-Message-State: AOJu0Ywza5hZ28UAn4sW6YifLQ1AtoeUPy32wPVdveweViW/qkIErNVn
	w7YiMFc4W8g9gSNYHRYgusO7MWNe70bv0v4erWyavTWvl8IQ0bzq
X-Google-Smtp-Source: AGHT+IEe7vhlIAeDY/l9HRi57nmdwBnO4mPv9Nua8spEcdISEd1nxQi0dLK2zEHQj5HT3Dg6I+5azw==
X-Received: by 2002:a17:902:ecc3:b0:20c:f3be:2f8b with SMTP id d9443c01a7336-20cf3be31f0mr10163475ad.30.1728845246588;
        Sun, 13 Oct 2024 11:47:26 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c348f41sm52681965ad.289.2024.10.13.11.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:47:26 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 0/3] Enhance min heap API with non-inline functions and optimizations
Date: Mon, 14 Oct 2024 02:47:00 +0800
Message-Id: <20241013184703.659652-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add non-inline versions of the min heap API functions in lib/min_heap.c
and updates all users outside of kernel/events/core.c to use these
non-inline versions. Additionally, it micro-optimizes the efficiency of
the min heap by pre-scaling the counter, following the same approach as
in lib/sort.c. Documentation for the min heap API has also been added
to the core-api section.

Regards,
Kuan-Wei

Kuan-Wei Chiu (3):
  lib/min_heap: Introduce non-inline versions of min heap API functions
  lib min_heap: Optimize min heap by prescaling counters for better
    performance
  Documentation/core-api: Add min heap API introduction

 Documentation/core-api/index.rst    |   1 +
 Documentation/core-api/min_heap.rst | 291 ++++++++++++++++++++++++++++
 drivers/md/bcache/Kconfig           |   1 +
 drivers/md/dm-vdo/Kconfig           |   1 +
 fs/bcachefs/Kconfig                 |   1 +
 include/linux/min_heap.h            | 202 ++++++++++++-------
 kernel/events/core.c                |   6 +-
 lib/Kconfig                         |   3 +
 lib/Kconfig.debug                   |   1 +
 lib/Makefile                        |   1 +
 lib/min_heap.c                      |  70 +++++++
 11 files changed, 508 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/core-api/min_heap.rst
 create mode 100644 lib/min_heap.c

-- 
2.34.1


