Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AD14FA581
	for <lists+linux-bcache@lfdr.de>; Sat,  9 Apr 2022 08:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiDIHAW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 Apr 2022 03:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbiDIHAV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Apr 2022 03:00:21 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF94A3F5
        for <linux-bcache@vger.kernel.org>; Fri,  8 Apr 2022 23:58:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id r13so15868914wrr.9
        for <linux-bcache@vger.kernel.org>; Fri, 08 Apr 2022 23:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qIg8V8eUlKkANOKwRaIOQ4QqDSdNDl6HvyVqymueIUU=;
        b=JzFVVgFQW5sHbcTp86VfeCDLa+Bpp/XeTDjWcLyFWAB6ABtmQaIJJ9/GorIqi8ozW3
         wRYJC/nV0NoKM6jQ+fD3icwncPiBHQySVREyR1kHCzoYrmfadbqQPcuXAm6J+1WtOpCQ
         DITpjYzNlHcdT2yHla7F/m4A87vfIt4+PIz6g/xd5ekd6+OUTdH3YXiHapo4vrP7K4rL
         /i1NP3GqIINXyLNwb9srhCMIIEyx/Gv9p+2BIXhIWJ+fYon7coReVCkGCmXBAhFVUdbq
         9rN1kP8sTMzxLMpGIsU1MthDT5tPwvH/VuRPMrEaInN+p8KYDI+bewySNiWaWH11PjZK
         GKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qIg8V8eUlKkANOKwRaIOQ4QqDSdNDl6HvyVqymueIUU=;
        b=cWaGMGA1Php8E9kG13ecGCg8FpDPo9TC1VSTR5WaTZVLCnEGg9QGkTfg0yYioGZSkB
         Ykcycv21y7F9kxTXl156Tht3oLuuWKtEo0/6aJF1ts/6VdPFWj33J87cPdY/C+tehL+R
         51QZWBNiRoTGY2/hC4I89J0Sv85Tp6Waeoz74A9g2S3090lf1VWu/N0Qv/mqeBDCKNcc
         WZ3lyCCuCBVtz5QfqAho4g8htgrFKEFP19+F7dP4XI6lb5GGiioueWW+JyWTe8oxgJXZ
         gkcp3pA4lOFT5KeTRN2L7DxIQ6sYsyHavVvHM8MuYDMvghGy2nNiT6DdhdsKgSMtrlBh
         /jpw==
X-Gm-Message-State: AOAM533WORqEQnlhtGuDXpB44F7a23IX7/Iu263bWx9vLx3VqPyLn8hJ
        0338pnyAUGbpCP3FQS2oMQtKZYiFjLmymVIcaIkBoCs+oP8=
X-Google-Smtp-Source: ABdhPJyOygDwLyis/ZiTBYWyMEbrVeKxWRqyTz71ZLPmWo3d0HDimdrLkWXyhENyg+cDCpbZkQW/svJwItmRS/PbH84=
X-Received: by 2002:adf:f841:0:b0:207:a09b:d3cf with SMTP id
 d1-20020adff841000000b00207a09bd3cfmr517437wrq.161.1649487493651; Fri, 08 Apr
 2022 23:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220407171643.65177-1-colyli@suse.de>
In-Reply-To: <20220407171643.65177-1-colyli@suse.de>
From:   =?UTF-8?B?5p2O56OK?= <noctis.akm@gmail.com>
Date:   Sat, 9 Apr 2022 14:58:00 +0800
Message-ID: <CAMhKsXkfr6btADZbTcFEJ3y8Qi=A0cQk32pqwa7htbSGHrU_uA@mail.gmail.com>
Subject: Re: [PATCH] bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

>
> The kworker routine update_writeback_rate() is schedued to update the
> writeback rate in every 5 seconds by default. Before calling
> __update_writeback_rate() to do real job, semaphore dc->writeback_lock
> should be held by the kworker routine.
>
> At the same time, bcache writeback thread routine bch_writeback_thread()
> also needs to hold dc->writeback_lock before flushing dirty data back
> into the backing device. If the dirty data set is large, it might be
> very long time for bch_writeback_thread() to scan all dirty buckets and
> releases dc->writeback_lock.

Hi Coly,
cached_dev_write() needs dc->writeback_lock, if  the writeback thread
 holds writeback_lock too long, high write IO latency may happen. I wonder
if it is a nicer way to limit the scale of the scanning in writeback.
For example,
just scan 512GB in stead of the whole cache disk=E3=80=82
