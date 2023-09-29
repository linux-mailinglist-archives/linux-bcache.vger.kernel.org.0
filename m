Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997C57B3918
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Sep 2023 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjI2Rpe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Sep 2023 13:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjI2Rpd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Sep 2023 13:45:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7340C19F
        for <linux-bcache@vger.kernel.org>; Fri, 29 Sep 2023 10:45:32 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d9443c01a7336-1bd9b4f8e0eso111563755ad.1
        for <linux-bcache@vger.kernel.org>; Fri, 29 Sep 2023 10:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696009531; x=1696614331; darn=vger.kernel.org;
        h=content-language:content-transfer-encoding:mime-version:user-agent
         :date:message-id:subject:to:from:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7q/Ocr/LuKL/ulDcDi15T1xKwBX0O06v5b0Uc8oaurk=;
        b=WBe084bLFx8G5iQ5WWT1KgceL1pswI/SY6RnBEK9OPUXQ34aa8hC1KeBdS47aHcGXz
         aICzlj/p4hE3B7daAP5QvKMWDYKmUkQL8KoQy5MFi8c+qBA1379h46E8PCgcBEJN7TWW
         Uu2LV99zbU2bOP/xSwANgbGPk0Vo0ZdFm/P+DQtQy64XD/dLLNa13DCBEjn51Vi1k1X4
         Qc3oLW6RLH3zKj7sXv5R6qT1Bfjco8pMJjSX//g0OcadXUMqGAjUh4IrMnjO/qduGWND
         0Dr/IgbHPhn5Lk20RL3t2zlkvlDy6UymwrWddPArjPeVU2D8zrQirYVUlV/pZtfS7l1j
         8fPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696009531; x=1696614331;
        h=content-language:content-transfer-encoding:mime-version:user-agent
         :date:message-id:subject:to:from:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7q/Ocr/LuKL/ulDcDi15T1xKwBX0O06v5b0Uc8oaurk=;
        b=a/MCCWV0+0jPrdE8b/a9T5+Yp/Fayweplc7HR+XEgG1v9CmCQO3SMnbprYFJNGRHIO
         CAtvBTo3OXRnMgoZ7+7mSZ+6/om5gZRr0geBBzxVsrb38C1jhJN+nhWQPBaViqMFmjZS
         Fo0p+GRvcmTWOuJKOEz9ibTy1VdaW4SploOV/SF2I/W+ka99n3dTuSJGMfPfJNrpUjdH
         g7VXXQ55Hf1FHimxN1yJP1rdTwDHssSoHqJDbS3js5+hXk0fXIpvHyCNwYDtK8Mulj7p
         EwPXat1ZGGC6zAo4MunxKcXh9t2Oz6NgKUMdewKfZfG5F8X4Z8QLgXbt9LoGPK9G4Zbd
         B7tQ==
X-Gm-Message-State: AOJu0YzN35gJM55DCaDxKkXoD0OfwcyKek922g6Jseey/WUy7zUqHgU8
        8q1aEyVo5dVKGQGUrlyQpbZqs2aAl3G2Hg==
X-Google-Smtp-Source: AGHT+IHNFLH51/BDR3w6I53tdMJ0rmA0qckGHVxATzHbUh/8V5gQqb3HvFAjK2HWuAUQp+BKse9lfw==
X-Received: by 2002:a17:902:ed54:b0:1c6:a2b:5a5c with SMTP id y20-20020a170902ed5400b001c60a2b5a5cmr4937372plb.34.1696009531504;
        Fri, 29 Sep 2023 10:45:31 -0700 (PDT)
Received: from [192.168.43.79] ([47.15.3.9])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902a50400b001b567bbe82dsm17094494plq.150.2023.09.29.10.45.29
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 10:45:31 -0700 (PDT)
Reply-To: businesssolutionsrocks23@gmail.com
From:   Noor Bano <noorbano3685@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: RE: Meeting request
Message-ID: <0c026895-25cc-a99a-dcb3-3a7da63ac869@gmail.com>
Date:   Fri, 29 Sep 2023 23:15:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi

Circling back on my previous email if you have a requirement for Mobile 
App OR Web App Development service.

Can we schedule a quick call for Tuesday (3rd october) or Wednesday (4th 
October)?

Please suggest a suitable time based on your availability. Please share 
your contact information to connect.

Best Regards,
Noor Bano

On Tuesday 22 August 2023 5:43 PM, Noor Bano wrote:


Hi

We are a Software development company creating solutions for many 
industries across all over the world.

We follow the latest development approaches and technologies to build 
web applications that meet your requirements.

Our development teams only use modern and scalable technologies to 
deliver a mobile or web application the way you mean it.

Can we have a quick call to discuss if we can be of some assistance to 
you? Please share your phone number to reach you.

Thanks & Regards,
Noor Bano
