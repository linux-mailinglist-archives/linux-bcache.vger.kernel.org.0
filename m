Return-Path: <linux-bcache+bounces-21-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C49097F1863
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 17:18:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74A911F251FF
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 16:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FC91DFED;
	Mon, 20 Nov 2023 16:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ononwLHh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C893F94
	for <linux-bcache@vger.kernel.org>; Mon, 20 Nov 2023 08:18:14 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-35b0b36716fso373865ab.0
        for <linux-bcache@vger.kernel.org>; Mon, 20 Nov 2023 08:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700497093; x=1701101893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J12cYkOScUy5xSSf3mgekEtSW0rko94tb57vwGqSmO8=;
        b=ononwLHhvIBhdEoTKNRnx9jNviugI9CTbYEPJ2zDysx/c7H3LSNlMiBMInFMlK+Pc8
         nWLAvCVwR/55T+cKxwURnChu8Ztn25O2bWG6wwoTZV6JkT6uJOWLP+WnzWZia1LtMN57
         mT/bnCcvCGuIL6tuh2S5Uq4y3yLRHoA+ty7DKWEz0IGLzjrCRiUSTfLC7ioxH1SC1UAY
         yBuxWUAI0MVPboolwyulKWPSJOecLy48Jyd5qrM5ly0zX9oOmolqZTClbGzadQKX3zFv
         itXV/6vZucAbplmE7hYbF3bdQWWX+x3MgWdZtecIlR1XpxNL3Z8ylj34tqjH3pbJmSUa
         Qw2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700497093; x=1701101893;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J12cYkOScUy5xSSf3mgekEtSW0rko94tb57vwGqSmO8=;
        b=EGwKcTTDHmC7OFIAY9vXqw+KZDjh8bSeJTfVZsG3Vy0jyeZxS3p/O5cjvrDn4uT2S4
         LLsV+pCx26zuRkyxpfLuoW0CQ/NYmDrGhrMkqD6NYkNNUL+aiaefApGg7+7yd/lZtclY
         +uhHfytNsZT8xbvEPzVOjWCgCW9tVttFU2VwKLPAOk/fJRFPaj9Zl0LK/UGvfmEk8RV2
         dE8iWmPJBBDhswjvO78hUKL0VXlI5CYmgepfV1JOhJS+gETAZfsm7ZLmaJTUaoXma14R
         FUD6lji84Nc5d4I/w2bBX+U33C7TaWajADcepLKCN7JLAukzNlh1cLMR3ij5HJPNQ/Gz
         D2iA==
X-Gm-Message-State: AOJu0YxVLP+ONyZnF5iD3yWGUxXUx/zlDfgzDNiVJsiG5VKCYRTlhgov
	8dMuvqTomlbpr2FPh8MlWi3CcOEVsRB+L/dQy6zDXw==
X-Google-Smtp-Source: AGHT+IGk4Nm+ppiSvIPBdsyw1do8SbEPnzHzotfzbuC8o5V3Mv2fiBpR0pOKV0gBFrt95nzKaSLIng==
X-Received: by 2002:a05:6e02:3611:b0:34f:b824:5844 with SMTP id ci17-20020a056e02361100b0034fb8245844mr6508689ilb.3.1700497093517;
        Mon, 20 Nov 2023 08:18:13 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w13-20020a92ad0d000000b0035af9da22b1sm1521725ilh.43.2023.11.20.08.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 08:18:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Coly Li <colyli@suse.de>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
In-Reply-To: <20231120052503.6122-1-colyli@suse.de>
References: <20231120052503.6122-1-colyli@suse.de>
Subject: Re: [PATCH 00/10] bcache-next 20231120
Message-Id: <170049709206.66373.14314097595716560727.b4-ty@kernel.dk>
Date: Mon, 20 Nov 2023 09:18:12 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615


On Mon, 20 Nov 2023 13:24:53 +0800, Coly Li wrote:
> Here are recent bcache patches tested by me on Linux v6.7-rc1 and can be
> applied on branch block-6.7 of linux-block tree.
> 
> In this series, Colin provids useful code cleanup, some small and still
> important fixes are contributed from Mingzhe, Rand. Also there are some
> fixes and a code comments patch from me.
> 
> [...]

Applied, thanks!

[01/10] bcache: avoid oversize memory allocation by small stripe_size
        commit: baf8fb7e0e5ec54ea0839f0c534f2cdcd79bea9c
[02/10] bcache: check return value from btree_node_alloc_replacement()
        commit: 777967e7e9f6f5f3e153abffb562bffaf4430d26
[03/10] bcache: remove redundant assignment to variable cur_idx
        commit: be93825f0e6428c2d3f03a6e4d447dc48d33d7ff
[04/10] bcache: prevent potential division by zero error
        commit: 2c7f497ac274a14330208b18f6f734000868ebf9
[05/10] bcache: fixup init dirty data errors
        commit: 7cc47e64d3d69786a2711a4767e26b26ba63d7ed
[06/10] bcache: fixup lock c->root error
        commit: e34820f984512b433ee1fc291417e60c47d56727
[07/10] bcache: fixup multi-threaded bch_sectors_dirty_init() wake-up race
        commit: 2faac25d7958c4761bb8cec54adb79f806783ad6
[08/10] bcache: replace a mistaken IS_ERR() by IS_ERR_OR_NULL() in btree_gc_coalesce()
        commit: f72f4312d4388376fc8a1f6cf37cb21a0d41758b
[09/10] bcache: add code comments for bch_btree_node_get() and __bch_btree_node_alloc()
        commit: 31f5b956a197d4ec25c8a07cb3a2ab69d0c0b82f
[10/10] bcache: avoid NULL checking to c->root in run_cache_set()
        commit: 3eba5e0b2422aec3c9e79822029599961fdcab97

Best regards,
-- 
Jens Axboe




