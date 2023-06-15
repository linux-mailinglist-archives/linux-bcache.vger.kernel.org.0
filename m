Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278D2731A14
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jun 2023 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbjFONeu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Jun 2023 09:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344154AbjFONeO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2023 09:34:14 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A75B30FE
        for <linux-bcache@vger.kernel.org>; Thu, 15 Jun 2023 06:33:47 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-6664ac3be47so396386b3a.0
        for <linux-bcache@vger.kernel.org>; Thu, 15 Jun 2023 06:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686836027; x=1689428027;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVR+vT8DdsvA3Z3S0QOP6jSANdRArM8WL8xik+euJ7U=;
        b=DEJZBn0jRo+nrmjAYfVbkW/mbWTo9TPUh5Zk5FdEZ9pNqXulFJpZdIL6dCbj+nxtYS
         zcZv11ORnK6I++2adpuFhjl0ft85vJq3OrXtav0aI4US0+3khl91+a+ZlJDjLB7gWOV3
         TL/LSTeYzjcZht0650UgDtwxgCQToPTz4Uzvkm/KwSKr+RKEp0szPSV+3yrBpWxmz8aF
         BGLXUncI1pi+EeL4aNxttKZJn2qmvi5Hv1XuwsJh3/vCgx6DZU8SLeXeo0PgjwCmr6RU
         lrTtxLpVwmaHEHOVBQTylSMH/9Qk0C2lntzNe91kKp6XtrlCCXay1JBOj9YToZZZ+RIj
         MWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686836027; x=1689428027;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVR+vT8DdsvA3Z3S0QOP6jSANdRArM8WL8xik+euJ7U=;
        b=PAtoz1Xvf0JPxEw7Yy5hMJ2KSFfJx4lZY8+TeWSg97yDpgPuhqzh+sLf63Qyy/EK4J
         2j0Re+Cyrfx9L6JnlL9iMaWuzyr9OReacwssXMsIkuuXAm7i8lOrWv51eJ8bVO2CQrU0
         4nKyhSBoaBJ5a0YBgARvBtx2E8gzEVbrNJFWZx1EeLpg2elgLCszM1VkwNFrRXJy3JGh
         90QmM8v59bA8SG/6VEoOCX17f2AhiTIiRe843Agv11v0gCp+orunItwx//vlH3FFVEmH
         QygRe6CQjcdfMs/IuIeP4KO0lTmMU2eZIeSAxggK114B6//1fNbm0iClS8CFURcGGcOe
         XFeA==
X-Gm-Message-State: AC+VfDx8ndHZtKiCPohrx9ASwOdvsxoqf8Zdpq+sPQMDalbpy1umWhJr
        76jGmZb0cHnxxsNvLqRnqj/KWPCHZn1jicVIGCI=
X-Google-Smtp-Source: ACHHUZ4hYDWKSnGc0F3oLOsil5ywgqcuGr7h8N6KfecEA3vYODtqH0U/YpLcDAf/Ug39JuiuTrNGXw==
X-Received: by 2002:a05:6a20:8e19:b0:11a:efaa:eb88 with SMTP id y25-20020a056a208e1900b0011aefaaeb88mr15781079pzj.3.1686836026892;
        Thu, 15 Jun 2023 06:33:46 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x17-20020aa793b1000000b00640dbf177b8sm12062928pff.37.2023.06.15.06.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 06:33:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20230615121223.22502-1-colyli@suse.de>
References: <20230615121223.22502-1-colyli@suse.de>
Subject: Re: [PATCH 0/6] bcache-next 20230615
Message-Id: <168683602549.2139966.16055841086380737489.b4-ty@kernel.dk>
Date:   Thu, 15 Jun 2023 07:33:45 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-c6835
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Thu, 15 Jun 2023 20:12:17 +0800, Coly Li wrote:
> I start to follow Song Liu's -next style to submit bcache patches to
> you. This series are minor fixes I tested for a while, and generated
> based on top of the for-6.5/block branch from linux-block tree.
> 
> The patch from Mingzhe Zou fixes a race in bcache initializaiton time,
> rested patches from Andrea, Thomas, Zheng and Ye are code cleanup and
> good to have them in.
> 
> [...]

Applied, thanks!

[1/6] bcache: Convert to use sysfs_emit()/sysfs_emit_at() APIs
      commit: a301b2deb66cd93bae0f676702356273ebf8abb6
[2/6] bcache: make kobj_type structures constant
      commit: b98dd0b0a596fdeaca68396ce8f782883ed253a9
[3/6] bcache: Remove dead references to cache_readaheads
      commit: ccb8c3bd6d93e7986b702d1f66d5d56d08abc59f
[4/6] bcache: Remove some unnecessary NULL point check for the return value of __bch_btree_node_alloc-related pointer
      commit: 028ddcac477b691dd9205c92f991cc15259d033e
[5/6] bcache: Fix __bch_btree_node_alloc to make the failure behavior consistent
      commit: 80fca8a10b604afad6c14213fdfd816c4eda3ee4
[6/6] bcache: fixup btree_cache_wait list damage
      commit: f0854489fc07d2456f7cc71a63f4faf9c716ffbe

Best regards,
-- 
Jens Axboe



