Return-Path: <linux-bcache+bounces-289-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90BD487D6C7
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Mar 2024 23:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CBC91F2220A
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Mar 2024 22:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C87C59B66;
	Fri, 15 Mar 2024 22:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A9/jPWwE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8AA1774E
	for <linux-bcache@vger.kernel.org>; Fri, 15 Mar 2024 22:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710542734; cv=none; b=eLYC5P/YJq6UVnxxDURKSs1N2amFp3q95ijTMAlLVHzKLlZoYyj2rYqnBY0MUj8AHQMnJm3ee01iMF8WFBNwzA25eSKz56y7fd/PQm6DlP9SKm1GzNRpsIdcbstmgxUWkuIR+3Cs3kVRQ0WwRiOgI1Dz56g/IHQIT1/Rui4LrdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710542734; c=relaxed/simple;
	bh=/7AXFXcO6IqRgr9LcA/UlUd50xXlOqxMAdpmJoLYA6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EYDz2i/p2muTm332ecVU76RpmMm1+Q7rjFKnAICar/LZsofph6MPbEBe+pcLQVZRJd37oV2Mc7Kmz6rqbS8NQ+DNz7Rym8RUONSFYb/10cZilmriMGc+vTy8m104ruMTmKdRkPiDAQidrfwWsV91j9n5WlFebl/djeL+oCbnrxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A9/jPWwE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd0ae66422fso5222251276.0
        for <linux-bcache@vger.kernel.org>; Fri, 15 Mar 2024 15:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710542730; x=1711147530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iGqYG9TghWeU/d9kBKO7wS7rT4foueT7LQaaWZLNf14=;
        b=A9/jPWwEv1cUACzwXZwOimP9CoCmK7Clqduj6/A8DwYvYbWsQN843mBHc3P5v2egKj
         hsr4/KyqjV8/NOn28GKOiwbVy1KjRY+kn4FhI93QQ9knJd73aSp/HcxTRPdXVX7tn9rk
         NL2KBke+L9wnZuFXEWmtSbr3K0hgLGjoQ49tn8H2h49H0mulvxFcoMoY8M4ff6E1tnxL
         iwzrsUnXCGt/N80btOQm4ahiwFMZCR1uW4q7u0wJJoTJ0ZMS5OEWvcImoW3rERbkxSB0
         iSSzvMf4kTr4FosyDK2ZXj9hqJRjPhRefsELuxi3rIvJc5iuddPBUIPg6dk52CwYoj/u
         Ikjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710542730; x=1711147530;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iGqYG9TghWeU/d9kBKO7wS7rT4foueT7LQaaWZLNf14=;
        b=Rp9Wbf61PyoI2kVLMjeTu0ZD1o8VN1Ar9ykJh3SmoqRWKnx7q1fftKryQ4JhbhAb6N
         ZmiHx9m44X/NVAsw5NQ9aUyz/PTXyn6D5Wsa2igg5tB6o4RfMyZbSFz+p9u0ocTnziTK
         UvabImuWa04yOa75keZ6GVSzHyWuNvdpilBHJjxR1kj9acfWMDwU9vetbv5rDzggHS79
         XnetdTPxI33OfOEMNhgqzR51+Ip0BJkb05q+8A/C9gIH/xpBn0LoghlQIFkC/aU9F3XI
         nq7e6KRFjmtnfHTep4Y4jpPBueUAbflBtE6qUfNrXw6C/A9ufEjwr8SbSiHhPe5YtbJO
         AN2A==
X-Forwarded-Encrypted: i=1; AJvYcCWwnR0jfEPzoDhyV8Pv7BdIqxOFGWq4UzIDDUQX6GAXAam8D0CcLhatTF2AHAktR4LKUxnZL0FANVdk/Mxga+5PNchWVqa0ezBV4jc3
X-Gm-Message-State: AOJu0YyVgU3SM3emB2S+7a4w6CaSjaOM8hdSr4abPVHuwxZAv3jVEqEn
	HibkowTQdAk7Uag1wg3YkCkh7U481LirgfEaRtMYbUW6mjr2gB5EKBbvoSdppmlg5WQ2wTGt9pe
	Q7AefrqrHrP750QU4HQ==
X-Google-Smtp-Source: AGHT+IH18TRXui2wiSGE0GpHCaNUXocmps6yyB/ntIDCBw/6QIwcLdhT0VYK9UnMrpcrZheuHsVSjyYoR272m5IH
X-Received: from robertpang.svl.corp.google.com ([2620:15c:2c4:202:f3f1:9e4a:5a4e:878b])
 (user=robertpang job=sendgmr) by 2002:a5b:388:0:b0:dcc:5463:49a8 with SMTP id
 k8-20020a5b0388000000b00dcc546349a8mr1847762ybp.6.1710542730042; Fri, 15 Mar
 2024 15:45:30 -0700 (PDT)
Date: Fri, 15 Mar 2024 15:45:27 -0700
In-Reply-To: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240315224527.694458-1-robertpang@google.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
From: Robert Pang <robertpang@google.com>
To: colyli@suse.de
Cc: dongsheng.yang@easystack.cn, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

We found this patch via google.

We have a setup that uses bcache to cache a network attached storage in a l=
ocal SSD drive. Under heavy traffic, IO on the cached device stalls every h=
our or so for tens of seconds. When we track the latency with "fio" utility=
 continuously, we can see the max IO latency shoots up when stall happens, =
=20

latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar 15 21=
:14:18 2024
  read: IOPS=3D62.3k, BW=3D486MiB/s (510MB/s)(11.4GiB/24000msec)
    slat (nsec): min=3D1377, max=3D98964, avg=3D4567.31, stdev=3D1330.69
    clat (nsec): min=3D367, max=3D43682, avg=3D429.77, stdev=3D234.70
     lat (nsec): min=3D1866, max=3D105301, avg=3D5068.60, stdev=3D1383.14
    clat percentiles (nsec):
     |  1.00th=3D[  386],  5.00th=3D[  406], 10.00th=3D[  406], 20.00th=3D[=
  410],
     | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  414], 60.00th=3D[=
  418],
     | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00th=3D[=
  462],
     | 99.00th=3D[  652], 99.50th=3D[  708], 99.90th=3D[ 3088], 99.95th=3D[=
 5600],
     | 99.99th=3D[11328]
   bw (  KiB/s): min=3D318192, max=3D627591, per=3D99.97%, avg=3D497939.04,=
 stdev=3D81923.63, samples=3D47
   iops        : min=3D39774, max=3D78448, avg=3D62242.15, stdev=3D10240.39=
, samples=3D47
...
=20
<IO stall>

latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar 15 21=
:21:23 2024
  read: IOPS=3D26.0k, BW=3D203MiB/s (213MB/s)(89.1GiB/448867msec)
    slat (nsec): min=3D958, max=3D40745M, avg=3D15596.66, stdev=3D13650543.=
09
    clat (nsec): min=3D364, max=3D104599, avg=3D435.81, stdev=3D302.81
     lat (nsec): min=3D1416, max=3D40745M, avg=3D16104.06, stdev=3D13650546=
.77
    clat percentiles (nsec):
     |  1.00th=3D[  378],  5.00th=3D[  390], 10.00th=3D[  406], 20.00th=3D[=
  410],
     | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  418], 60.00th=3D[=
  418],
     | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00th=3D[=
  494],
     | 99.00th=3D[  772], 99.50th=3D[  916], 99.90th=3D[ 3856], 99.95th=3D[=
 5920],
     | 99.99th=3D[10816]
   bw (  KiB/s): min=3D    1, max=3D627591, per=3D100.00%, avg=3D244393.77,=
 stdev=3D103534.74, samples=3D765
   iops        : min=3D    0, max=3D78448, avg=3D30549.06, stdev=3D12941.82=
, samples=3D765

When we track per-second max latency in fio, we see something like this:

<time-ms>,<max-latency-ns>,,,
...
777000, 5155548, 0, 0, 0
778000, 105551, 1, 0, 0
802615, 24276019570, 0, 0, 0
802615, 82134, 1, 0, 0
804000, 9944554, 0, 0, 0
805000, 7424638, 1, 0, 0

fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dlibaio --n=
ame=3Dlatency_test --filename=3Dfio --bs=3D8k --iodepth=3D1 --size=3D900G  =
--readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_lat_log=3Dlat --=
log_avg_msec=3D1000 --log_max_value=3D1
=20
We saw a smiliar issue reported in https://www.spinics.net/lists/linux-bcac=
he/msg09578.html, which suggests an issue in garbage collection. When we tr=
igger GC manually via "echo 1 > /sys/fs/bcache/a356bdb0-...-64f794387488/in=
ternal/trigger_gc", the stall is always reproduced. That thread points to t=
his patch (https://www.spinics.net/lists/linux-bcache/msg08870.html) that w=
e tested and the stall no longer happens.

AFAIK, this patch marks buckets reclaimable at the beginning of GC to unblo=
ck the allocator so it does not need to wait for GC to finish. This periodi=
c stall is a serious issue. Can the community look at this issue and this p=
atch if possible?

We are running Linux kernel version 5.10 and 6.1.

Thank you.

