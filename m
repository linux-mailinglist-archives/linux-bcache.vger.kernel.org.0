Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D287750A165
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Apr 2022 15:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiDUOAm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 21 Apr 2022 10:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344635AbiDUOAl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Apr 2022 10:00:41 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8997337A2F
        for <linux-bcache@vger.kernel.org>; Thu, 21 Apr 2022 06:57:51 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x17so8844038lfa.10
        for <linux-bcache@vger.kernel.org>; Thu, 21 Apr 2022 06:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=LZK9xR0DKNDPur1vAoTvXMZdBiXRJFA9KgcHYjlBU5Y=;
        b=Z/0mLL5+929s26SfEW3j5cxogqdskF4lTYVUfGWTIJGzj6z+I/Ni+Qw2vZ2ZYEJAOS
         SnBFNPhnk/x1Vs4EmV0FD1DG7D9e8AYqbOT8attoSQSTdsDB4ewsh4nUigQxgC0VW1Sx
         PUxnaiHBGui5BeBSkqjvy9GLkHLpTjHqo8GPlVD0UCdhe/qRCmnEnSmT9HHueZSpAiGy
         M0g5WkoeO+EvMZCbJpk/UV9EzNYFmCBI4tpx14sr/C+udZChgGwp85y4cj+RvEqqMx+y
         9xO4b1tWHiezAzv1BpcSLS+RjibaXxBlHOlaYpXJVvQNyabF5327TVopR7EsurQRyVHG
         R7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=LZK9xR0DKNDPur1vAoTvXMZdBiXRJFA9KgcHYjlBU5Y=;
        b=CDdr8Ov87mmFgMNApvvJZdhUafUQ9IqcVyeDSxY7MTXBShcPg1rx9+FZv7qpD270/C
         RJM9u6IyGiFRVMzNmeX/qkQnOLKxoK678eFzK7HGz2kX4nuYA5aiw4ncq8LOpaMR3Xh+
         TATGKBJHcAGhWNisRYF1A3de9Iz2mbxWPPJKe3DEQYB7YrnUSkrELC4nsrPCqNWdnRbI
         MAVBPMI8uDI3d7ydZepbNLwCcUD+kSjjBMfmqXf5llXsveoUdNr/Op7FQMMMzZFlssnw
         amiHYUnxa4dbOSbMTz2sS7+MaXafMjagS3yv/QkIYOT6QwU4F9tiA3GFGD2ite1L6hzJ
         mDhQ==
X-Gm-Message-State: AOAM532DcXC/3yeJoF3ZQ45hIvECOd1vfvOmQEa97hEwUEbAofUCVyx+
        YKgN+aT99FbBi7/MQbguo+0vPBnJXGGOGBzSGpA=
X-Google-Smtp-Source: ABdhPJw3L1HuLX1/KrlxC9A/Bbq65xNByCMEUhW2GY6Wxcy9eux2WencTEAahDVJYS8+xVi7Riu1q/rq5F4rH5Vs7NA=
X-Received: by 2002:a05:6512:b0e:b0:44a:a5a0:f60e with SMTP id
 w14-20020a0565120b0e00b0044aa5a0f60emr18409139lfu.669.1650549469770; Thu, 21
 Apr 2022 06:57:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:3c8d:0:0:0:0 with HTTP; Thu, 21 Apr 2022 06:57:49
 -0700 (PDT)
Reply-To: liaahill650@gmail.com
From:   lia ahill <barrekennastevenson@gmail.com>
Date:   Thu, 21 Apr 2022 06:57:49 -0700
Message-ID: <CAM0Fr9YBzAbxz-3XNvfGPdPUWXR86Tx421rX2pE3ftdM45J6Kw@mail.gmail.com>
Subject: I have a proposal for you?
To:     ike_jonah@yahoo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=ADVANCE_FEE_5_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URG_BIZ autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Good day to you,
My name is lia ahill, iam contacting you based on the release of the
funds of my late client who shares the same last name as you,
Please if you are interested in more information on the transaction,
Kindly get bact to me urgently, if this proposal doesn=E2=80=99t interest y=
ou
or you can not handle it,
Please delete it and forget about this proposal as it is neither a
joke nor a child=E2=80=99s play.
Regards.
Lia ahill ?
